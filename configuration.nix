# NixOS 系统配置入口
# 各功能模块位于 ./nixos/ 目录下，按职责分目录：
#   boot/      引导与内核
#   hardware/  自动生成的硬件描述 + 驱动 / GPU / 虚拟化
#   security/  账户与提权
#   desktop/   桌面会话（niri / noctalia）
#   programs/  本地化与系统级软件包
# 运行 `nixos-rebuild switch --flake .#Scil-nixos` 以应用更改

{ ... }:

{
  imports = [
    ./nixos/hardware/configuration.nix

    # 系统子模块
    ./nixos/boot
    ./nixos/hardware
    ./nixos/network.nix
    ./nixos/programs/locale.nix
    ./nixos/audio.nix
    ./nixos/fonts.nix
    ./nixos/security/users.nix
    ./nixos/programs.nix
    ./nixos/services.nix
    ./nixos/plasma.nix
    ./nixos/programs/packages.nix

    # 桌面会话（液态玻璃 niri + noctalia 相关系统侧配置）
    ./nixos/desktop

    # 由 flake.nix 抽出的第三方接线模块
    ./nixos/boot/lanzaboote.nix # lanzaboote Secure Boot
    ./nixos/programs/nur.nix # NUR 仓库字体
  ];

  nixpkgs.overlays = [
    (import ./nixos/desktop/niri/overlay.nix) # 新增：注册液态玻璃版 niri
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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };
}
