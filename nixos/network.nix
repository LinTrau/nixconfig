# 网络、防火墙与代理配置
_:

{
  networking = {
    hostName = "Scil-nixos";
    networkmanager.enable = true;

    # 这台机器是笔记本，会连公共 / 校园 WiFi，所以防火墙必须开。
    # 之前 enable = false 时，下面这些本机服务对整个局域网裸奔：
    #   7897 mihomo 混合代理、9097 mihomo 控制接口（无鉴权）、35495 mihomo
    #   8080 bonsai llama-server、8099 Deep-Live-Cam webui、1716 kdeconnect
    firewall = {
      enable = true;

      # 这些是虚拟网卡/隧道，里面的流量不再过过滤：
      #   Mihomo / vnt-tun —— mihomo 的 tun 模式和 vnt 组网
      #   docker0 / br-+  —— 容器访问宿主机端口（openlist 5244 是 docker 发布）
      trustedInterfaces = [
        "Mihomo"
        "vnt-tun"
        "docker0"
        "br-+"
      ];

      # mihomo 的 tun 会改写路由，严格 rpfilter 会把回包丢掉
      checkReversePath = false;

      # 只保留确认要从局域网访问的服务。想收紧就删掉对应行；
      # 8099（Deep-Live-Cam，无鉴权）默认不开，需要手机/平板远程用时再取消注释。
      allowedTCPPorts = [
        7897 # mihomo 混合代理（config.yaml 里 allow-lan: true）
        8080 # bonsai llama-server（有 --api-key-file 鉴权）
        1716 # KDE Connect
        8099 # Deep-Live-Cam wan-animate webui（gradio，无鉴权）
      ];
      allowedUDPPorts = [
        7897 # mihomo UDP 转发（QUIC / DNS）
        1716 # KDE Connect
      ];
    };
  };
}
