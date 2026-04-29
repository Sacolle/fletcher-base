{
    description = "Flake for compiling this";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
        old-nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    };
    outputs = { self, nixpkgs, old-nixpkgs }: 
    let 
        config = {
	    allowUnfree = true;
	    cudaSupport = true;
	};
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system config; };
        old-pkgs = import old-nixpkgs { inherit system config; };
        # setup-script = pkgs.writeShellScriptBin ""
    in
    {
        devShells.${system} = {
            default = pkgs.mkShell.override { stdenv = old-pkgs.gcc12Stdenv; } {
                buildInputs = [
                    old-pkgs.cudaPackages_12_2.cuda_nvcc
                    old-pkgs.cudaPackages_12_2.cuda_cudart
                ];
                shellHook = ''
                    export DRIVER_DIR=~  
                    source ${self}/setup-cuda-drivers.sh
                '';
                BACKEND = "CUDA";
                CUDA_GPU_SM = "sm_89";
            };
            cpu-experiments = pkgs.mkShell {
                BACKEND = "OpenMP";
            };
        };
    };
}
