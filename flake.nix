{
  description = "NixOS config flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
     
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-root.url = "github.srid/flake-root";
    mission-control.url = "github.PlatonicSystems/mission-control";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs @ {
    nixpkgs,
    flake-parts,
    flake-root,
    mission-control,
    treefmt-nix
    ...
  }: let
    lib = import ./nix/lib {lib = nixpkgs.lib;} // nixpkgs.lib;
  in 
    (flake-parts.lib.evalFlakeModule
      {
        inherit inputs;
        specialArgs = {inherit lib;};
      }
      {
        debug = true;
        imports = [
          (_: {
            perSystem = {inputs', ...}: {
              module.args.pkgs = inputs'.nixpkgs.legacyPackages;
              module.args.lib = lib;
            };
          })
          treefmt-nix.flakeModule
          flake-root.flakeModule
          mission-control.flakeModule
          ./nix
          ./nixos
        ];
        systems = ["x86_64-linux"];
      })
    .config
    .flake;
}
