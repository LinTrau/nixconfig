{
  description = "ROG Flake";

  nixConfig.extra-experimental-features = [
    "flakes"
    "nix-command"
    "pipe-operators"
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

    cursor = {
      url = "github:omarcresp/cursor-flake/main";
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

    #openmodelica-nix = {
    # url = "github:LinTrau/openmodelica-nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    nixGL.url = "github:nix-community/nixGL";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      lanzaboote,
      nur,
      tinyMediaManager-flake,
      zen-browser,
      cursor,
      home-manager,
      lazyvim-nix,
      #openmodelica-nix,
      ...
    }:
    {
      nixosConfigurations = {
        "Scil-nixos" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix

            #openmodelica-nix.nixosModules.default

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
                  cursor.packages.${pkgs.stdenv.hostPlatform.system}.default
                  tinyMediaManager-flake.packages.${pkgs.stdenv.hostPlatform.system}.default
                  zen-browser.packages."x86_64-linux".default
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
