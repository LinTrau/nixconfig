# 系统服务配置
{ ... }:

{
  services = {
    printing.enable = true;

    asusd.enable = true;
    fwupd.enable = true;
    ratbagd.enable = true;

    # xrdp：暂时禁用（X11 远程桌面，且默认走 startplasma-x11）。
    # 如需远程访问：niri(Wayland) 环境建议用 wayvnc（VNC）；rustdesk 也可。
    xrdp = {
      enable = false;
      defaultWindowManager = "startplasma-x11";
      openFirewall = true;
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    mihomo = {
      enable = true;
      configFile = "/home/scil/Scil/config.yaml";
      tunMode = true;
    };

    flatpak.enable = true;

    envfs.enable = true;

    # UPower：noctalia 的 battery 组件靠它读电池（org.freedesktop.UPower D-Bus 服务）
    upower.enable = true;
  };
}
