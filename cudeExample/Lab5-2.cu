// This exercise is for student to get familiarized with passing data between host and device
#include <stdio.h>

__global__ 
void vector_add(int *d_c, int *d_a, int *d_b, int n){
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    d_c[i] = d_a[i] + d_b[i];
    //printf("GPU[%d] done!\n", i);
    }


int main(void){
   int N = 4;
   int a[N] = {22, 13, 16,  5};
   int b[N] = { 5, 22, 17, 37};
   int c[N];

   int *d_a, *d_b, *d_c;

   cudaMalloc((void**)&d_a, sizeof(int)*N);
   cudaMalloc((void**)&d_b, sizeof(int)*N);
   cudaMalloc((void**)&d_c, sizeof(int)*N);

   cudaMemcpy(d_a, a, sizeof(int)*N, cudaMemcpyHostToDevice);
   cudaMemcpy(d_b, b, sizeof(int)*N, cudaMemcpyHostToDevice);

   vector_add<<<N,1>>>(d_c, d_a, d_b, N); // N (4) threads

   cudaMemcpy(c, d_c, sizeof(int)*N, cudaMemcpyDeviceToHost);

   cudaFree(d_a);
   cudaFree(d_b);
   cudaFree(d_c);

   printf("A = [%2d  %2d  %2d  %2d]\n", a[0], a[1], a[2], a[3]);
   printf("B = [%2d  %2d  %2d  %2d]\n", b[0], b[1], b[2], b[3]);
   printf("C = [%2d  %2d  %2d  %2d]\n", c[0], c[1], c[2], c[3]);
   return 0;
   }
