{
  description = "ROG Flake";

  nixConfig.extra-experimental-features = ["flakes" "nix-command" "pipe-operators"];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    cursor = {
      url = "github:omarcresp/cursor-flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    re3-flake = {
      url = "github:gujial/re3-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tinyMediaManager-flake = {
      url = "github:gujial/tinyMediaManager-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty.url = "github:ghostty-org/ghostty";
    nixGL.url = "github:nix-community/nixGL";

    caelestia-cli.url = "github:caelestia-dots/cli";
    hexecute.url = "github:ThatOtherAndrew/Hexecute";
  };

  outputs = inputs @ { self, flake-parts, lanzaboote, ... }:
    flake-parts.lib.mkFlake {
      inherit inputs;
    } {
      systems = [ "x86_64-linux" ];

      flake = {
        homeManagerModules = import ./modules/home-manager;
        nixosConfigurations = {
          "Scil-nixos" = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./configuration.nix
              
              inputs.home-manager.nixosModules.home-manager
	      {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.scil = import ./home.nix;
                home-manager.backupFileExtension = "bak";
                home-manager.extraSpecialArgs = { inherit inputs; };
              }
    
              lanzaboote.nixosModules.lanzaboote
              (
                { pkgs, lib, ... }:
                {
                  environment.systemPackages = [
                    pkgs.sbctl
                  ];

                  boot.loader.systemd-boot.enable = lib.mkForce false;

                  boot.lanzaboote = {
                    enable = true;
                    pkiBundle = "/var/lib/sbctl";
                  };
                }
              )

              # Zen Browser
              ({ pkgs, ... }: {
                environment.systemPackages = [ 
                  inputs.zen-browser.packages."x86_64-linux".twilight 
                ];
              })
      
             (
              { pkgs, ... }:
              {
                environment.systemPackages = [
                  inputs.cursor.packages.${pkgs.stdenv.hostPlatform.system}.default
                  inputs.re3-flake.packages.${pkgs.stdenv.hostPlatform.system}.re3-vc
                  inputs.tinyMediaManager-flake.packages.${pkgs.stdenv.hostPlatform.system}.default
                ];
              }
            )

              # NUR
              inputs.nur.modules.nixos.default
              ({ pkgs, ... }: {
                fonts.packages = [
                  pkgs.nur.repos.rewine.ttf-wps-fonts
                  pkgs.nur.repos.rewine.ttf-ms-win10
                ];
              })
            ];
          };
        };
      };
    };
}
