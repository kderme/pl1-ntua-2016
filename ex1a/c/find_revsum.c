#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <errno.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>

#define CHUNK 1024
#define MAX_SIZE 100002

char *string_revsum(char *buf, unsigned int size)
{
	int i,temp;
	int carry = 0;
	char *result = (char *)malloc((size+1) * sizeof(char));
	if(result==NULL){
		perror("malloc1");
		exit(1);
	}
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
    int i,n, rev;
    FILE *fptr;

	char *buf;
	int fd;
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
    unsigned int buf_size=CHUNK;
	unsigned int total_size = 0;
    while(total_size<MAX_SIZE){
//		printf("%d->",total_size);
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
            perror("realloc:");
            exit(1);
        }
        buf_size += CHUNK;
        total_size+=cnt;
    }
    close(fd);
//	printf("%s\nsize=%d\n", buf, total_size);

   for(i=0; isdigit(buf[i]); i++)
        ;
	unsigned int size = i;
//	printf("\nsize=%d\n", size);
	char output[40];
	strcpy(output,"found.");
	strcpy(output+strlen("found."),argv[1]);

	fptr = fopen(output,"w");
	if(!fptr){
        perror("fopen_2:");
        exit(1);
    }
	char *result = string_revsum(buf, size);
	int carry = result[0]-'0';
	for(i=1-carry; i<=size; i++)
		fprintf(fptr, "%c",result[i]);
	fprintf(fptr,"\n");

	free(result);
	if(fclose(fptr)){
        perror("fclose:");
        exit(1);
    }
    return 0;
}



