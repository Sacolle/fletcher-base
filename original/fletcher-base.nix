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
    cudaNativeBuildInputs = with cudaPackages; [ cuda_nvcc cuda_cudart autoAddDriverRunpath];
    cudaBuildInputs = with cudaPackages; [ cuda_nvcc cuda_cudart ];

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

    installPhase = "mkdir -p $out/bin && cp ModelagemFletcher.exe $out/bin/fletcher-base";
} // (lib.optionalAttrs CUDAbackend { CUDA_GPU_SM = cuda-arquitecture; })))
