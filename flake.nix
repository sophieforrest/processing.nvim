{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    neorocks.url = "github:nvim-neorocks/neorocks";
    processing-lsp.url = "git+https://codeberg.org/sophieforrest/processing-lsp.git";
    pre-commit-hooks-nix.url = "github:cachix/pre-commit-hooks.nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs @ {
    self,
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
        inputs',
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config = {};
          overlays = [
            inputs.neorocks.overlays.default
          ];
        };

        checks.neorocks-test = pkgs.neorocksTest {
          inherit (pkgs) neovim;
          extraPackages = builtins.attrValues {
            inherit (pkgs) processing universal-ctags;
            inherit (pkgs.tree-sitter-grammars) tree-sitter-java;
            processing-lsp = inputs'.processing-lsp.packages.default;
          };
          luaPackages = _: [];
          name = "processing.nvim";
          src = self;
          version = "scm-1";
        };

        packages.default = let
          name = "processing.nvim";
        in
          pkgs.vimUtils.buildVimPlugin {
            pname = name;
            version = "1.0.0";

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
          doctags = {
            enable = true;
            name = "doctags";
            entry = "${pkgs.neovim-unwrapped}/bin/nvim -c 'helptags doc' +q";
            files = "\\.(txt)$";
            pass_filenames = false;
          };
          editorconfig-checker = {
            args = ["--config" ".editorconfig-checker.json"];
            enable = true;
          };
          luacheck.enable = true;
          markdownlint = {
            enable = true;
            excludes = ["CHANGELOG.md"];
          };
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
