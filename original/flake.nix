{
    description = "Flake for compiling this";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };

    outputs = { self, nixpkgs }: 
    let 
        system = "x86_64-linux";
    in
    {
        devShells.${system}.default = pkgs.mkShell {
            buildInputs = with pkgs; [
                # for bash to work properlly inside vscode
                bashInteractive
                gdb
                gcc
            ];
            # export StarPU and hwloc store locations 
            # for use in vscode intellisence
            OMP_FLAG = "-fopenmp";

            shellHook = ''
                export SHELL=/run/current-system/sw/bin/bash
            '';
        };
    };
}
