#include <cuda_runtime.h>
#include <sys/time.h>
#include <time.h>
#include <stdio.h>

// #define N 1<<20
// #define THREADS 1024
// #define BLOCKS 1024

__global__ void square(float *d_out,float *d_in)
{

    int id=threadIdx.x;
    float f=d_in[id];
    d_out=f*f;
}


int main()
{
    int AS=64;
    int AB=AS*sizeof(float);

    float h_in[AS];

    for(int i=0;i<AS;i++)
    h_in[i]=float(i);

    float h_out[AS];
    float *d_in;
    float *d_out;
    cudaMalloc((void **)&d_in,AB);
    cudaMalloc((void **)&d_out,AB);
    cudaMemcpy(d_in,h_in,AB,cudaMemcpyHostToDevice);
    square<<<1,AS>>>(d_out,d_in);
    cudaMemcpy(h_out,d_out,AB,cudaMemcpyDeviceToHost);
    for(int i=0;i<AS;i++)
    cout<<h_out[i]<<",";
    cudaFree(d_in);
    cudaFree(d_out);
    return 0;

}