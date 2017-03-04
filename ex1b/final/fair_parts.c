/*	FAIR_PARTS c Implementation
 *	National Technical University of Athens
 *	created by Dermentzis Konstantinos
 *
 *	Compile with flag -DVDBG for some
 *	cool outputs
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>
#include <limits.h>

#include <stdint.h>

#if defined(VDBG)
# define DBG 1
#else
# define DBG 0
#endif

/*  any function to return an long long int between a and b	*/
#define FN(a,b) (a+b)/2 

int M, N;

int * fits (long long arr[], long long limit)
{
	int take_all=0;
	int interval_index=N-2;
	int *interval=malloc((N-1)*sizeof(int));
	int i;
	long long sum=0LL;
	for(i=M-1; i>=0; i--){
		if(arr[i]>limit){
			free(interval);
			return NULL;
		}
		if(interval_index==i)
			take_all=1;
		if(take_all){
			if(i!=interval_index){
				printf("take all error(limit=%lld)\n", limit);
				free(interval);
		 		exit(1);
			}
			interval[interval_index--]=i;
			continue;
		}
		sum+=arr[i];
		if (sum>limit){
			sum=arr[i];
			if(interval_index==-1){
				free(interval);
				return NULL;
			}
			interval[interval_index--]=i;
			/*  there are i+1 elements on the left
			 *  and interval_index more intervals
			 */

		}
	}
	return interval;
}

void prnt(long long *arr, int * obstacles)
{
	int i;
	int o_index=0;
	for(i=0; i<M; i++){
		printf("%lld",arr[i]);
		if(i!=M-1)
			printf(" ");
		if(obstacles!=NULL && o_index<N-1 && i==obstacles[o_index]) {
			printf("| ");
			o_index++;	
		}
	}
	printf("\n");
}

void binary(long long *arr)
{
	long long sum =0LL;
	int i;
	int *a;
	for(i=0; i<M; sum+=arr[i++]);
	long long x = 1LL;
	long long y = sum;
	long long fn;
	while(1){
		if(N==1){
			a=NULL;
			break;
		}
		fn = FN(x,y);
		if(DBG) 	printf("(%lld,%lld,%lld)->",x,fn,y);
		a = fits(arr,fn);
		if (a==NULL){
//			printf("NULL");
			if(y>fn)
				x = fn+1;
			else{
				printf("error y=fn and it doesn`t fit\n");
				exit(1);
			}
		}
		else{
			if(fn==x){
				if(DBG) printf("[%lld]\n", fn);
				break;
			}
			y=fn;
			free(a);
		}
	}
	if(DBG){  for(i=0;i<N-1; i++) printf("(%d)",a[i]); }
	if(DBG==0)  prnt(arr, a);

	if(a) free(a);
}

int main(int argc, char *argv[])
{
	FILE *fin;
	fin=fopen(argv[1],"r");
	if(fin==NULL){
		perror("fopen");
		exit(1);
	}
	int i;
	int ret;
	if((ret=fscanf(fin, "%d %d", &M, &N))!=2){
		perror("fscanf");
		exit(1);
	}
	fgetc(fin);
	long long *arr;
	arr=malloc(M*sizeof(long long));
	if(arr==NULL){
		perror("malloc");
		exit(1);
	}
	for(i=0; i<M; i++){
		if(fscanf(fin,"%lld", &arr[i])!=1){
			perror("fscanf");
			exit(1);
		}
	}
	if(fclose(fin)!=0){
		perror("fclose");	
		exit(1);
	}
	/* M and N are global */
	if(LLONG_MAX<42000ULL*10000000ULL){
		printf("not long enough\n");
		exit(1);
	}
	binary(arr);
	free(arr);
	return 0;
}
