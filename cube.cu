%%cu
#include <cuda_runtime.h>
#include <sys/time.h>
#include <time.h>
#include <stdio.h>



__global__ void cube(float *d_out,float *d_in)
{

    int id=threadIdx.x;
    printf("Thread id  : %d\n",id);
    float f=d_in[id];
    d_out[id]=f*f*f;
}

int main()
{
    const int AS=96;
    const int AB=AS*sizeof(float);

    float h_in[AS];

    for(int i=0;i<AS;i++)
    h_in[i]=float(i);

    float h_out[AS];
    float * d_in;
    float * d_out;
    cudaMalloc((void **)&d_in,AB);
    cudaMalloc((void **)&d_out,AB);
    cudaMemcpy(d_in,h_in,AB,cudaMemcpyHostToDevice);
    //square<<<1,AS>>>(d_out,d_in);
    cube<<<dim3(1,1,1),dim3(AS,1,1)>>>(d_out,d_in);
    cudaMemcpy(h_out,d_out,AB,cudaMemcpyDeviceToHost);
    for(int i=0;i<AS;i++)
    printf("%f,",h_out[i]);
    cudaFree(d_in);
    cudaFree(d_out);
    return 0;

}