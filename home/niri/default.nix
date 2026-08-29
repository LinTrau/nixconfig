# home/niri.nix
# niri 相关的用户态配置入口，风格对齐你原来的 home/packages.nix、home/zsh.nix 等模块

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
    nautilus
  ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  # 顶栏/启动器/通知/会话菜单/壁纸/锁屏统一交给 noctalia，见 home/noctalia/default.nix
  imports = [
    ../noctalia
  ];
}
