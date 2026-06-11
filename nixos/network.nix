# 网络、防火墙与代理配置
_:

{
  networking = {
    hostName = "Scil-nixos";
    networkmanager.enable = true;

    firewall = {
      enable = false;
      trustedInterfaces = [
        "Mihomo"
        "vnt-tun"
      ];
      checkReversePath = false;
    };
  };
}
