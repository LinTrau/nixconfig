{
  description = "ROG Flake";

  nixConfig.extra-experimental-features = [
    "flakes"
    "nix-command"
    "pipe-operators"
  ];

  nixConfig.extra-substituters = [
    "https://comfyui.cachix.org"
    "https://nix-community.cachix.org"
  ];
  nixConfig.extra-trusted-public-keys = [
    "comfyui.cachix.org-1:33mf9VzoIjzVbp0zwj+fT51HG0y31ZTK3nzYZAX0rec="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

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

    lazyvim-nix = {
      url = "github:gujial/lazyvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tinyMediaManager-flake = {
      url = "github:gujial/tinyMediaManager-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    nixGL.url = "github:nix-community/nixGL";

    dsh-nix = {
      url = "github:tsx8/dsh-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comfyui-nix = {
      url = "github:utensils/comfyui-nix";
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      lanzaboote,
      nur,
      tinyMediaManager-flake,
      zen-browser,
      home-manager,
      lazyvim-nix,
      dsh-nix,
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

            # 外部 flake 软件包
            (
              { pkgs, system, ... }:
              {
                environment.systemPackages = [
                  tinyMediaManager-flake.packages.${pkgs.stdenv.hostPlatform.system}.default
                  zen-browser.packages."x86_64-linux".default
                  inputs.dsh-nix.packages.${pkgs.stdenv.hostPlatform.system}.deepseek-harness

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
