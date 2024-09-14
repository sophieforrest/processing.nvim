{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem = {pkgs, ...}: {
        packages.default = let
          name = "processing.nvim";
        in
          pkgs.vimUtils.buildVimPlugin {
            pname = name;
            version = "0.1.0";

            src = builtins.path {
              inherit name;
              path = ./.;
            };
          };
      };
    };
}
