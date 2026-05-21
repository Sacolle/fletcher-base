CC=$(GCC)
CFLAGS=-O0 -g
GPUCC=$(NVCC)
GPUCFLAGS=-Xptxas="-v" --maxrregcount 127 -arch=$(CUDA_GPU_SM)
LIBS=-L/usr/local/cuda/lib64 -lcudart -lstdc++ $(GCC_LIBS) $(NIX_CUDA_LDFLAGS)
