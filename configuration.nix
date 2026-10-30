# NixOS 系统配置入口，模块按职责分文件：
#   boot.nix      引导 / 内核 / Secure Boot
#   hardware.nix  硬件描述 / 文件系统 / 驱动 / 虚拟化
#   security.nix  账户 / doas / polkit
#   programs.nix  本地化 / 系统级程序与软件包
#   desktop/      登录器与 niri 会话（系统侧）
# 应用：nixos-rebuild switch --flake .#Scil-nixos

{ ... }:

{
  imports = [
    ./nixos/boot.nix
    ./nixos/hardware.nix
    ./nixos/network.nix
    ./nixos/programs.nix
    ./nixos/audio.nix
    ./nixos/fonts.nix
    ./nixos/security.nix
    ./nixos/services.nix

    ./nixos/desktop/greetd.nix
    ./nixos/desktop/niri
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;

      # 写在系统配置里才对所有用户生效（flake 的 nixConfig 只对 trusted user 有效）
      extra-substituters = [
        "https://comfyui.cachix.org"
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "comfyui.cachix.org-1:33mf9VzoIjzVbp0zwj+fT51HG0y31ZTK3nzYZAX0rec="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "electron-39.8.10" ];
  };

  system.stateVersion = "25.05";
}
