{
    # derivation dependencies
    lib,
    stdenv,
    CUDAbackend   ? false,
    cuda-arquitecture ? "",
    cudaPackages,
    autoAddDriverRunpath, #
    OpenMPbackend ? false,
    OpenACCbackend ? false,
}:
let 
    cudaNativeBuildInputs = with cudaPackages; [ cuda_nvcc autoAddDriverRunpath];
    cudaBuildInputs = with cudaPackages; [ cuda_cudart cuda_cccl ];

    trueto1 = b: if b then 1 else 0;
    backend-count = builtins.foldl' (acc: x: acc + (trueto1 x)) 0 [ CUDAbackend OpenMPbackend OpenACCbackend ];
    backend-name = 
        if CUDAbackend then "CUDA" 
            else (if OpenMPbackend then "OpenMP" 
                else (if OpenACCbackend then "OpenACC" else ""));
in
assert lib.assertMsg (backend-count == 1) ''
    One backend target needs to be selected and only one, 
    backends selected is ${toString backend-count}
'';
stdenv.mkDerivation (f: 
({
    pname = "fletcher-base";
    system = "x86_64-linux";
    version = "0.1";

    BACKEND = backend-name;

    src = ./.;

    nativeBuildInputs = lib.optional CUDAbackend cudaNativeBuildInputs;

    buildInputs = lib.optional CUDAbackend cudaBuildInputs;

    makeFlags = lib.optionals CUDAbackend [
        "NIX_CUDA_CFLAGS=-I${cudaPackages.cuda_cudart.dev}/include"
	"NIX_CUDA_LDFLAGS=-L${cudaPackages.cuda_cudart.lib}/lib"
];
	# aPackages.cuda_cudart.dev}/include 

    installPhase = "mkdir -p $out/bin && cp ModelagemFletcher.exe $out/bin/fletcher-base";
} // (lib.optionalAttrs CUDAbackend { CUDA_GPU_SM = cuda-arquitecture; })))
