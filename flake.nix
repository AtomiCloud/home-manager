{
  description = "Home Manager configuration for AtomiCloud";

  inputs = {
    # util
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-2411.url = "nixpkgs/nixos-24.11";

    atomipkgs.url = "github:AtomiCloud/nix-registry/v1.0.0";
    atomi-upstream-pkgs.url = "github:AtomiCloud/home-manager-upstream";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self

      # utils
    , flake-utils
    , treefmt-nix
    , pre-commit-hooks
    , home-manager

    , nixpkgs
    , nixpkgs-2411

    , atomipkgs
    , atomi-upstream-pkgs

    } @inputs:
    let profiles = import ./profiles.nix; in
    {
      homeConfigurations = builtins.listToAttrs (map
        (profile:
          let
            system = "${profile.arch}-${profile.kernel}";
            pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
            pkgs-2411 = import nixpkgs-2411 { inherit system; config.allowUnfree = true; };
            pre-commit-lib = pre-commit-hooks.lib.${system};
            atomi = atomipkgs.packages.${system};
            atomi-upstream = atomi-upstream-pkgs.packages.${system};
          in
          {
            name = profile.user;
            value = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [ ./home.nix ];
              extraSpecialArgs = {
                inherit atomi profile pkgs-2411 atomi-upstream;
              };
            };
          })
        profiles);
    } // (
      flake-utils.lib.eachDefaultSystem
        (system:
        let
          pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
          pkgs-2411 = import nixpkgs-2411 { inherit system; config.allowUnfree = true; };
          pre-commit-lib = pre-commit-hooks.lib.${system};
          atomi = atomipkgs.packages.${system};
        in
        let
          out = rec {
            pre-commit = import ./nix/pre-commit.nix {
              inherit pre-commit-lib formatter packages;
            };
            formatter = import ./nix/fmt.nix {
              inherit treefmt-nix pkgs;
            };
            packages = import ./nix/packages.nix {
              inherit pkgs atomi pkgs-2411;
            };
            env = import ./nix/env.nix {
              inherit pkgs packages;
            };
            devShells = import ./nix/shells.nix {
              inherit pkgs env packages;
              shellHook = checks.pre-commit-check.shellHook;
            };
            checks = {
              pre-commit-check = pre-commit;
              format = formatter;
            };
          };
        in
        with out;
        {
          inherit checks formatter packages devShells;
        }
        )

    );
}
