{
    description = "Flake for compiling this";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
        old-nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
	#cudart.url = "github:nixos/nixpkgs?ref=25d1b84f5c90632a623c48d83a2faf156451e6b1";
    };

    outputs = { self, nixpkgs, old-nixpkgs }: 
    let 
	config = { 
	    allowUnfree = true;
	    cudaSupport = true;
	    #cudaVersion = "12";
	};
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system config; };
        old-pkgs = import old-nixpkgs { inherit system config; };
	#cuda_cudart = (import cudart { inherit system config; }).cudaPackages.cuda_cudart;
    in
    {
        devShells.${system}.default = pkgs.mkShell.override { stdenv = pkgs.gcc13Stdenv; } {
            buildInputs = [
                old-pkgs.cudaPackages_12_4.cuda_nvcc
                old-pkgs.cudaPackages_12_4.cuda_cudart
            ];
            # BACKEND = "CUDA";
            # CUDA_GPU_SM = "sm_89";
        };
    };
}
