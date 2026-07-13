{
    description = "Flake para o desenvolvimento do Fletcher-Base";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
	      nix-gl-host = {
          url = "github:numtide/nix-gl-host";
          inputs.nixpkgs.follows = "nixpkgs";
        };
        old-nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    };
    outputs = { self, nixpkgs, old-nixpkgs, nix-gl-host }: 
    let 
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
        old-pkgs = import old-nixpkgs { inherit system; config.allowUnfree = true; };

        fletcher = pkgs.callPackage ./fletcher-base.nix {
            stdenv = old-pkgs.gcc12Stdenv;
            CUDAbackend = true; 
            cuda-arquitecture = "native";
            cudaPackages = old-pkgs.cudaPackages_12_2;
        };
        nixglhost = nix-gl-host.defaultPackage.${system};
    in
    {
        packages.${system} = {
            default = fletcher;
            inherit fletcher;
        };
        devShells.${system} = {
            test = pkgs.mkShell { buildInputs = [ fletcher  pkgs.gdb nixglhost ]; };
        };
    };
}
