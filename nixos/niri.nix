# nixos/niri.nix
# 启用 niri（liquid-glass 补丁版）作为可选会话，与现有 Plasma 共存
# 在登录管理器里可以自由切换，不影响你原来的 plasma.nix

{ pkgs, ... }:

{
  # 用 overlays/niri-glass.nix 提供的 niri-glass 包替换默认会话二进制
  environment.systemPackages = with pkgs; [
    niri-glass
    xwayland-satellite
    # 启动器 / 通知 / 壁纸 / 锁屏 / 剪贴板统一由 noctalia 提供（见 home/noctalia）
    wl-clipboard # 截图键位 grim | wl-copy 仍要用到
    grim
    slurp # 截图
    playerctl
    brightnessctl
  ];

  # niri 需要的 session 文件；nixpkgs 的 niri 模块通常会自动注册
  # .desktop，但因为我们换成了自定义派生 niri-glass，这里手动补一份，
  # 避免登录界面里看不到它。
  services.displayManager.sessionPackages = [ pkgs.niri-glass ];

  # xwayland-satellite 之类 niri 常见依赖；greetd/gdm/sddm 任选，
  # 这里假设你复用现有 Plasma 用的 sddm，不重复配置 display-manager。
  security.polkit.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.dconf.enable = true; # GTK 应用读取主题需要
}
