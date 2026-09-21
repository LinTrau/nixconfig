# home/desktop/niri/default.nix
# niri 的用户态配置：自身窗口规则 config.kdl + 随 compositor 走的终端/文件管理器
#
# 顶栏 / 启动器 / 通知 / 会话 / 壁纸 / 锁屏由 noctalia 提供，但 noctalia 是
# 独立模块（见 ../noctalia 与 nixos/desktop/noctalia.nix），
# 由 home/desktop/default.nix 并列聚合——本文件不再反向 import 它。

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
    nautilus
  ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
}
