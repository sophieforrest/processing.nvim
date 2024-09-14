{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    pre-commit-hooks-nix.url = "github:cachix/pre-commit-hooks.nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.pre-commit-hooks-nix.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem = {
        config,
        pkgs,
        ...
      }: {
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

        devShells.default = pkgs.mkShell {
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };

        pre-commit.settings.hooks = {
          deadnix.enable = true;
          editorconfig-checker = {
            args = ["--config" ".editorconfig-checker.json"];
            enable = true;
          };
          luacheck.enable = true;
          statix.enable = true;
        };

        treefmt = {
          flakeFormatter = true;
          programs = {
            alejandra.enable = true;
            stylua.enable = true;
          };
          projectRootFile = "flake.nix";
        };
      };
    };
}
