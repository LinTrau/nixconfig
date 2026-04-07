# 系统服务配置
{ pkgs, ... }:

{
  services = {
    printing.enable = true;

    asusd.enable = true;
    fwupd.enable = true;
    ratbagd.enable = true;

    xrdp = {
      enable = true;
      defaultWindowManager = "startplasma-x11";
      openFirewall = true;
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
