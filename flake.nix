{
  description = "moul's nixpkgs";

  inputs = {
    # channel
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    nixpkgs-master = { url = "github:nixos/nixpkgs/master"; };
    nixpkgs-stable-darwin = {
      url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    };
    nixpkgs-silicon-darwin = {
      url = "github:thefloweringash/nixpkgs/apple-silicon";
    };
    nixos-stable = { url = "github:nixos/nixpkgs/nixos-20.09"; };

    # flake
    flake-utils = { url = "github:numtide/flake-utils"; };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # emacs
    spacemacs = {
      url = "github:syl20bnr/spacemacs/develop";
      flake = false;
    };
    emacs-overlay = { url = "github:nix-community/emacs-overlay"; };
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, emacs-overlay, ... }@inputs:
    let
      nixpkgsConfig = { mysystem }:
        with inputs; {
          config = { allowUnfree = true; };
          overlays = [
            (final: prev:
              let
                system = if mysystem == "aarch64-darwin" then
                  "x86_64-darwin"
                else
                  mysystem;
                nixpkgs-stable = if system == "x86_64-darwin" then
                  nixpkgs-stable-darwin
                else
                  nixos-stable;
                nixpkgs-silicon = if system == "x86_64-darwin" then
                  nixpkgs-silicon-darwin
                else
                  nixos-stable;
              in {
                master = nixpkgs-master.legacyPackages.${system};
                stable = nixpkgs-stable.legacyPackages.${system};
                silicon = nixpkgs-silicon.legacyPackages.${mysystem};

                spacemacs = inputs.spacemacs;
                emacsGcc = (import emacs-overlay final prev).emacsGcc;
              })
          ];
        };
      homeManagerConfig = with self.homeManagerModules; {
        imports = [ ./home.nix ];
      };
      overlays = [ ];
    in {
      homeConfigurations = {
        moul = inputs.home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, config, ... }: {
            imports = [ homeManagerConfig ];
            nixpkgs = nixpkgsConfig { mysystem = "x86_64-linux"; };
          };
          system = "x86_64-linux";
          homeDirectory = "/home/moul";
          username = "moul";
        };
        dockerTest = inputs.home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, config, ... }: {
            imports = [ homeManagerConfig ];
            nixpkgs = nixpkgsConfig { mysystem= "x86_64-linux"; };
          };
          system = "x86_64-linux";
          homeDirectory = "/root";
          username = "root";
        };
      };
      moul = self.homeConfigurations.moul.activationPackage;
      dockerTest = self.homeConfigurations.dockerTest.activationPackage;
    } // flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = import nixpkgs {
        inherit system;
        inherit (nixpkgsConfig { mysystem = system; }) config overlays;
      };
    });
}
