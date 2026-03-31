include ../config.mk
include flags.mk

ifndef CUDA_GPU_SM
echo $(error, CUDA GPU model not defined)
endif

all:	
	$(CC) $(CFLAGS) $(COMMON_FLAGS) -c cuda_driver.c
	$(GPUCC) $(GPUCFLAGS) $(COMMON_FLAGS) -c cuda_stuff.cu
	$(GPUCC) $(GPUCFLAGS) $(COMMON_FLAGS) -c cuda_propagate.cu
	$(GPUCC) $(GPUCFLAGS) $(COMMON_FLAGS) -c cuda_insertsource.cu

clean:
	rm -f *.o *.a

