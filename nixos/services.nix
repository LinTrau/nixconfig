# 系统服务
{ ... }:

{
  services = {
    printing.enable = true;

    asusd.enable = true;
    fwupd.enable = true;
    ratbagd.enable = true;

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

    # noctalia 的电池组件靠 UPower 读电量
    upower.enable = true;
  };
}
