# NixOS 系统配置入口
# 各功能模块位于 ./nixos/ 目录下
# 运行 `nixos-rebuild switch --flake .#Scil-nixos` 以应用更改

{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    # 系统子模块
    ./nixos/boot.nix
    ./nixos/hardware.nix
    ./nixos/network.nix
    ./nixos/locale.nix
    ./nixos/audio.nix
    ./nixos/fonts.nix
    ./nixos/users.nix
    ./nixos/programs.nix
    ./nixos/services.nix
    ./nixos/plasma.nix
    ./nixos/packages.nix
    ./nixos/niri.nix
  ];

  nixpkgs.overlays = [
    (import ./overlays/niri-glass.nix) # 新增：注册液态玻璃版 niri
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-39.8.10"
    ];
  };

  system.stateVersion = "25.05";

}
