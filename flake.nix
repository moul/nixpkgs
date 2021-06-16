{
  description = "moul's nixpkgs";

  inputs = {
    # channel
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    nixpkgs-master = { url = "github:nixos/nixpkgs/master"; };
    nixpkgs-stable-darwin = {
      url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    };
    nixpkgs-silicon-darwin = { url = "github:nixos/nixpkgs/staging-next"; };
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

  outputs = { self, nixpkgs, darwin, home-manager, flake-utils, emacs-overlay
    , ... }@inputs:
    let
      defaultSystems = flake-utils.lib.defaultSystems ++ [ "aarch64-darwin" ];
      nixpkgsConfig = { mysystem }:
        with inputs; {
          config = { allowUnfree = true; allowUnsupportedSystem = true; allowBroken = true; };
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
      homeManagerCommonConfig = with self.homeManagerModules; {
        imports = [ ./home.nix ];
      };
      darwinCommonConfig = { system, user }: [
        # self.darwinModules.services.emacsd
        # self.darwinModules.security.pam
        ./darwin
        home-manager.darwinModules.home-manager
        {
          nixpkgs = nixpkgsConfig { mysystem = system; };
          nix.nixPath = { nixpkgs = "$HOME/nixpkgs/nixpkgs.nix"; };
          users.users.${user}.home = "/Users/${user}";
          home-manager.useGlobalPkgs = true;
          home-manager.users.${user} = homeManagerCommonConfig;
        }
      ];
      linuxCommonConfig = { imports = [ homeManagerCommonConfig ./linux ]; };
      overlays = [ ];
    in {
      darwinConfigurations = {
        bootstrap-x86_64 = darwin.lib.darwinSystem {
          modules = [
            ./darwin/bootstrap.nix
            { nixpkgs = nixpkgsConfig { mysystem = "x86_64-darwin"; }; }
          ];
        };
        bootstrap-aarch64 = darwin.lib.darwinSystem {
          modules = [
            ./darwin/bootstrap.nix
            { nixpkgs = nixpkgsConfig { mysystem = "aarch64-darwin"; }; }
          ];
        };
        desktop-aarch64 = darwin.lib.darwinSystem {
          modules = darwinCommonConfig {
            system = "aarch64-darwin";
            user = "moul";
          };
        };
        desktop-x86_64 = darwin.lib.darwinSystem {
          modules = darwinCommonConfig {
            system = "x86-64-darwin";
            user = "moul";
          };
        };
      };
      linuxConfigurations = {
        server-x86_64 = inputs.home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/moul";
          username = "moul";
          configuration = { pkgs, config, ... }: {
            imports = [ linuxCommonConfig ];
            nixpkgs = nixpkgsConfig { mysystem = "x86_64-linux"; };
          };
        };
        dockerTest = inputs.home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, config, ... }: {
            #imports = [ homeManagerConfig ];
            nixpkgs = nixpkgsConfig { mysystem = "x86_64-linux"; };
          };
          system = "x86_64-linux";
          homeDirectory = "/root";
          username = "root";
        };
      };
    } // flake-utils.lib.eachSystem defaultSystems (system: {
      legacyPackages = import nixpkgs {
        inherit system;
        inherit (nixpkgsConfig { mysystem = system; }) config overlays;
      };
    });
}
