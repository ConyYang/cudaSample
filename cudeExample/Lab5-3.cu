// This exercise is for student to learn about data sharing and synchronization between threads

#include <stdio.h>
#define N 4  // number of elements in vector

__global__ 
void vector_mac(int *d_c, int *d_a, int *d_b, int n){
   __shared__ int tmp[N];      // shared memory

   int i = blockIdx.x * blockDim.x + threadIdx.x;
   tmp[i] = d_a[i] * d_b[i];

   __syncthreads(); // not really necessary for this simple program
   if (i==0){ // use thread 0 to perform the summation
      int sum = 0;
      for (int j = 0; j < n; j++)
         sum = sum + tmp[j];
       *d_c = sum; 
      }
    }

int main(void){
   int a[N] = {22, 13, 16,  5};
   int b[N] = { 5, 22, 17, 37};
   int c[1];

   int *d_a, *d_b, *d_c;
   cudaMalloc((void**)&d_a, sizeof(int)*N);
   cudaMalloc((void**)&d_b, sizeof(int)*N);
   cudaMalloc((void**)&d_c, sizeof(int));

   cudaMemcpy(d_a, a, sizeof(int)*N, cudaMemcpyHostToDevice);
   cudaMemcpy(d_b, b, sizeof(int)*N, cudaMemcpyHostToDevice);

   vector_mac<<<1,N>>>(d_c, d_a, d_b, N); // 1 thread block with N (4) threads

   cudaMemcpy(c, d_c, sizeof(int), cudaMemcpyDeviceToHost);

   cudaFree(d_a);
   cudaFree(d_b);
   cudaFree(d_c);

   printf("A = [%2d  %2d  %2d  %2d]\n", a[0], a[1], a[2], a[3]);
   printf("B = [%2d  %2d  %2d  %2d]\n", b[0], b[1], b[2], b[3]);
   printf("Answer = %d\n", c[0]);
   return 0;
   }
