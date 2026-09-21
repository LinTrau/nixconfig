# NUR（Nix User Repository）接线 + 由 NUR 提供的字体
#
# NUR 模块本身由 flake.nix 注入（nur.modules.nixos.default），
# 这里只放由 NUR 提供的字体包。

{ pkgs, ... }:

{
  fonts.packages = [
    pkgs.nur.repos.rewine.ttf-wps-fonts
    pkgs.nur.repos.rewine.ttf-ms-win10
  ];
}
