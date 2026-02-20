# 网络、防火墙与代理配置
_:

{
  networking = {
    hostName = "Scil-nixos";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      trustedInterfaces = [ "Mihomo" ];
      checkReversePath = false;
    };
  };
}
