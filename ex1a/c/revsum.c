/*    REVSUM c implementation	
 *    NTUA Programming Languages 1 2016
 *    written by Dermentzis Konstantinos
 *
 *	  Compile with -DVDBG for some cool
 *	  debugging outputs-but may flood stdout
 */


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>

#if defined(VDBG)
# define DGB 1
#else
# define DGB 0
#endif
 
#define CHUNK 10000
#define MAX_SIZE 200002

#define NEXT(x) (x!='9'? x+1 : '0')

typedef enum{DEFAULT=0, ACE_IS_CARRY=1} mode;
typedef enum{NFOUND=0, FOUND=1} result;

result revsum(char *, int, mode);
result _revsum(char *, int, char**, char**);

result _revsum(char *buf, int size, char ** num_result, char **copy_number)
{
	result ret;
	char *number= buf;
	if(number[0]!='1')
		/*	!1____ */
		return revsum(number, size, DEFAULT);
	else if (number[size-1]!='1'){
		/*   1____!1  */
		*num_result = buf+1;
		return revsum(number,size,ACE_IS_CARRY);
	}
	else if (number[1]!='1' && number[1]!='2')
		/*	 1!(1/2)____1	*/
		return revsum(number, size, DEFAULT);
	/*
	 *  1(1/2)_______1	check both 
	 *  -> (1/2)_______  
	 *  -> 1(1/2)_______ with first ACE_IS_CARRY
	 */
	*copy_number = realloc(*copy_number, (size+1)*sizeof(char));
	if(copy_number==NULL){
		perror("realloc");
		exit(1);
	}
	strcpy(*copy_number, number);
	*(*copy_number+size)='\0';
	ret = revsum(number,size, DEFAULT);
	if(ret==FOUND){
		/*no need to check further */
		return FOUND;
	}
	*num_result = *copy_number+1;
	ret = revsum(*copy_number,size,ACE_IS_CARRY);
	return ret;
}

int find_revsum(int n)
{
    int m, mod;
    
    m = 0;
    while(n > 0){
        mod = n % 10;
        m = 10*m + mod;
        n = n/10;
    }
    return m;

}


result revsum_brute_force(char *number, int size, mode md){
	int i,j;
	int dec_number=0;
	int ret;
	int pow = 1;
	if(size==1 && number[0]=='0' && md ==DEFAULT)
		return FOUND;
	for(i=0; i<size; i++){
		dec_number = 10*dec_number+number[i]-'0';
		pow*=10;
	}
	pow/=10;
	if (DGB)
		printf("%d<->", dec_number);
	int end = dec_number;
	int start = 1; 
	if(md==ACE_IS_CARRY)
		end=pow-1;
	else
		start = pow;
	for(i=end; i>=start; i--){
		ret = find_revsum(i);
		ret = i+ret;
		if(ret==dec_number){
			if (DGB) printf("%d\n",i);
			for(j=size-1; j>=0; j--){
				int digit = i%10;
				number[j] = '0' + digit;
				i=i/10;
				if(i==0) break;
			}
			if(md==ACE_IS_CARRY) 
				number[0]='1'; //just to be sure it did not change
			return FOUND;
		}
	}
	return NFOUND;
}

result revsum(char *number, int size, mode md)
{
	result ret;
	if (DGB) printf("{%c%c%c...%c%c,%d,%d",number[0],number[1],number[2], number[size-2], number[size-1],size,md);
	if(size==0)
		return FOUND;
	if(size==1)
		return revsum_brute_force(number, size, md);
	if(number[0] == '0'){
        if(number[size-1]=='0')
            return revsum(number+1,size-2, DEFAULT);
        else 
            return NFOUND;
    }
	if(size<8){
		if (DGB) printf(", 0}->");
		ret = revsum_brute_force(number, size, md);
		if (ret==NFOUND && md ==DEFAULT && number[0]=='1' && number[size-1]=='0'){
			number[size-1]= '0';
			ret = revsum(number, size-1, ACE_IS_CARRY);
			number[0] = '0';
			return ret;
		}
		return ret;
	}
    char save;
    if(number[0]!='1' || md == DEFAULT){
        /*  First digit is NOT ace */
        if(number[0]==number[size-1]){
	    if (DGB) printf(",1}->");
            /* i.e. x______x <-> ______*/
            ret = revsum(number +1, size-2, DEFAULT);
            if(ret==NFOUND)
                return NFOUND;
            number[size-1] = '0';
            return FOUND;
        }
        else if(number[0] == NEXT(number[size-1])){
            /* i.e. 3______2 <-> 1______ 
			 * i.e. 1______0 <-> 1______ 
			 */
	    if (DGB) printf(",2}->");
            save = number[0];
            number[0] = '1';
            ret = revsum(number, size-1, ACE_IS_CARRY);
            if(ret==NFOUND)
                return NFOUND;
            number[0] = save -1;
            number[size-1] = '0';
            return FOUND;
        }
        else{
            /* i.e. 4_______1 */
	    if (DGB) printf(",3}->");
            return NFOUND;
        }
    }

    /*  First digit is ace */
	/* md==ACE_IS_CARRY */
	
    int save1 = number[1]-'0';
    if (number[1] == number[size-1]){
        /* 1x___x , i.e. 14____4 <-> x9____5*/
	if (DGB) printf(",5}->");
        if(number[1]=='9')
            /* 19___9 */
            return NFOUND;

		/* sub 1 */
    int no_zero = size-2;
    while(number[no_zero] == '0'){
        number[no_zero] = '9';
        no_zero--;
        if(no_zero == 1){
			/* 1000...000x with ACE_IS_CARRY */
            return NFOUND;
        }
    }
    number[no_zero]--;

        ret = revsum(number+2, size-3, DEFAULT);
        if(ret==NFOUND)
            return NFOUND;
        number[1] = '9';
        number[size-1] = '0'+10+save1-9;
        return FOUND;
    }
    else if(number[1] == NEXT(number[size-1])){
        /*i.e. 14___3 <-> 1___(-1)*/
	if (DGB) printf(",6}->");
        number[1] = '1';
		if(number[size-1]!= '9'){
			/* sub 1, UNLESS 10_____9 */
	    	int no_zero = size-2;
    		while(number[no_zero] == '0'){
    	    	number[no_zero] = '9';
    	    	no_zero--;
        		if(no_zero == 1){
					/* 1400...0003 with ACE_IS_CARRY */
					if(size%2==0)
						/* i.e. 140003 */
 	           			return NFOUND;
					int j;
					/* i.e. 14003 <-9904 */
					for(j=1; j<=size/2; j++){
						number[j]='9';
						if(DGB) printf("9");
					}
					for(j=size/2+1; j<size-1;j++){
						number[j]='0';
						if(DGB) printf("0");
					}
					number[size-1]=NEXT(number[size-1]);
					if(DGB) printf("%c\n",number[size-1]);
					//number[0]='0';
					return FOUND;
    	    	}
    		}
    		number[no_zero]--;
		}

        ret = revsum(number+1, size-2, ACE_IS_CARRY);
        if(ret==NFOUND)
           return NFOUND;
        number[1] = '9';
        number[size-1] = '0'+10+save1-1-9;
        return FOUND;
    }
    else{
        /* i.e. 15___3 */
	if (DGB) printf(",7}->");
        return NFOUND;
    }
}

char *string_revsum(char *buf, int size)
{
        int i,temp;
        int carry = 0;
        char *result = (char *)malloc((size+2) * sizeof(char));
        if(result==NULL){
                perror("malloc1");
                exit(1);
        }
	result[size+1]='\0';
        for(i=size-1; i>=0; i--){
                temp=buf[i]-'0'+buf[size-i-1]-'0'+carry;
                result[i+1] = (temp%10) +'0';
                if(temp>=10)
                        carry =1;
                else
                        carry =0;
        }
        result[0]='0'+carry;
        return result;
}


int main(int argc, char *argv[])
{
    int fd, i;
    char *buf;

    if(argc!=2){
        printf("Usage: %s yourfile.txt\n",argv[0]);
        exit(1);
    }

    fd = open(argv[1], O_RDONLY);
    if(fd<=0){
        perror("open:");
        exit(1);
    }

    buf = malloc(CHUNK * sizeof(char));
    if(buf==NULL){
        perror("malloc");
        exit(1);
    }

    int cnt = 0;
    unsigned int total_size=0, buf_size=CHUNK;
    while(total_size<MAX_SIZE){
        cnt = read(fd, buf+total_size, CHUNK);
        if(cnt<0){
            perror("read");
            exit(1);
        }
        if(cnt==0){
            buf = realloc(buf, total_size+1);
            buf[total_size]='\0';
            break;
        }

        buf = realloc(buf, buf_size + CHUNK);      
        if(buf==NULL){
            perror("realloc");
            exit(1);
        }
        buf_size += CHUNK;
        total_size+=cnt;
    }
    close(fd);
    
   for(i=0; isdigit(buf[i]); i++)
        ;
	unsigned int size = i;
    /* OK we have the string */
	buf[size]='\0';
	char *check_res=malloc((size+1)*sizeof(char));
	if(check_res==NULL){
		perror("malloc");
		exit(1);
	}
	strcpy(check_res,buf);

    result ret;
	char *number_result=buf;
	FILE *fptr=stdout;
    char *copy_number;
    copy_number = (char *)malloc(0);

    ret = _revsum(buf, size,&number_result,&copy_number);
    if(ret == NFOUND){
        fprintf(fptr, "0\n");
    }
    else{
	if (DGB==0){
		char *result = string_revsum(number_result, strlen(number_result));
		if(result==NULL){
			perror("malloc");
			exit(1);
		}
		int carry=result[0]-'0';
		if(strcmp(result+1-carry, check_res)==0)
			fprintf(fptr, "%s\n",number_result);
		else{
        		fprintf(fptr, "0\n");
		}
		free(result);
	}
    }
    /* Ok now cleanup */
	if(check_res) free(check_res);
	if(copy_number) free(copy_number);
	copy_number=NULL;
 	fclose (fptr);
	if(buf) free(buf);
    return 0;
}
