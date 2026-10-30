# niri 用户态配置：窗口规则 config.kdl + 随 compositor 走的终端/文件管理器
# 顶栏、启动器、通知、壁纸、锁屏由 noctalia 提供（见 ../noctalia）
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
    nautilus
  ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
}
