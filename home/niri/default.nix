# home/niri.nix
# niri 相关的用户态配置入口，风格对齐你原来的 home/packages.nix、home/zsh.nix 等模块

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
    nautilus
    wlogout
  ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  # waybar / fuzzel 的配置放在各自模块里，见 home/waybar.nix、home/fuzzel.nix
  imports = [
    ../waybar
    ../fuzzel
    ../wlogout
  ];
}
