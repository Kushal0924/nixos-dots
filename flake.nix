{
  description = "NixOS system and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    umbriel = {
      url = "github:noctalia-dev/umbriel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-webapps = {
      url = "github:AniviaFlome/nix-webapps";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };

    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    millennium = {
      url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nhx.url = "github:Ra77a3l3-jar/nhx";

  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;

      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      hostNames = lib.attrNames (
        lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./hosts)
      );

      lintTools = with pkgs; [
        deadnix
        nixfmt
        statix
      ];
    in
    {
      nixosConfigurations = lib.genAttrs hostNames (
        host:
        lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./modules/options.nix
            ./hosts/${host}
          ];
        }
      );

      formatter.${system} = inputs.treefmt-nix.lib.mkWrapper pkgs {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
      };

      checks.${system}.lint =
        pkgs.runCommand "lint"
          {
            nativeBuildInputs = lintTools;
            src = ./.;
          }
          ''
            nixfmt --check .
            statix check .
            find . -name '*.nix' ! -name 'hardware-configuration.nix' -print0 \
              | xargs -0 deadnix --fail
            touch $out
          '';

      devShells.${system}.default = pkgs.mkShell {
        packages = lintTools;
      };
    };
}
