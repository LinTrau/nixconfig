{
  description = "ROG Flake";

  nixConfig.extra-experimental-features = [ "flakes" "nix-command" "pipe-operators" ];

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

    cursor = {
      url = "github:omarcresp/cursor-flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    re3-flake = {
      url = "github:gujial/re3-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lazyvim-nix = {
      url = "github:gujial/lazyvim-nix";
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

  outputs =
    inputs@{
      nixpkgs,
      lanzaboote,
      nur,
      re3-flake,
      tinyMediaManager-flake,
      zen-browser,
      cursor,
      home-manager,
      lazyvim-nix,
      ...
    }:
    {
      nixosConfigurations = {
        "Scil-nixos" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            
            lazyvim-nix.nixosModules.lazyvim
            
            home-manager.nixosModules.home-manager
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
                environment.systemPackages = [ pkgs.sbctl ];

                boot.loader.systemd-boot.enable = lib.mkForce false;

                boot.lanzaboote = {
                  enable = true;
                  pkiBundle = "/var/lib/sbctl";
                };
              }
            )

            # Zen Browser
            (
              { ... }:
              {
                environment.systemPackages = [
                  zen-browser.packages."x86_64-linux".twilight
                ];
              }
            )

            # 外部 flake 软件包
            (
              { pkgs, ... }:
              {
                environment.systemPackages = [
                  cursor.packages.${pkgs.stdenv.hostPlatform.system}.default
                  re3-flake.packages.${pkgs.stdenv.hostPlatform.system}.re3-vc
                  tinyMediaManager-flake.packages.${pkgs.stdenv.hostPlatform.system}.default
                ];
              }
            )

            # NUR
            nur.modules.nixos.default
            (
              { pkgs, ... }:
              {
                fonts.packages = [
                  pkgs.nur.repos.rewine.ttf-wps-fonts
                  pkgs.nur.repos.rewine.ttf-ms-win10
                ];
              }
            )
          ];
        };
      };
    };
}
