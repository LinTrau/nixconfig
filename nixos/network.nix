# 网络、防火墙与局域网统一入口（Caddy 反向代理）
_:

{
  networking = {
    hostName = "Scil-nixos";
    networkmanager.enable = true;

    firewall = {
      enable = true;

      # mihomo 的 tun / docker 网桥内部流量不再过滤
      trustedInterfaces = [
        "Mihomo"
        "vnt-tun"
        "docker0"
        "br-+"
      ];

      # mihomo tun 会改写路由，严格 rpfilter 会丢回包
      checkReversePath = false;

      allowedTCPPorts = [
        7897 # mihomo 混合代理（allow-lan: true）
        8080 # bonsai llama-server（有 api-key 鉴权）
        1716 # KDE Connect
        8099 # Deep-Live-Cam webui（gradio，无鉴权）
        8443 # Caddy 局域网入口
      ];
      allowedUDPPorts = [
        7897 # mihomo UDP 转发（QUIC / DNS）
        1716 # KDE Connect
      ];
    };
  };

  # 局域网统一入口：手机/平板访问 192.168.31.65:8443，由 Caddy 转到只监听
  # 127.0.0.1 的各 web UI，后端不直接暴露。新增服务复制一个 virtualHosts 条目，
  # 并把端口加进上面的 allowedTCPPorts。
  services.caddy = {
    enable = true;

    globalConfig = ''
      admin off
      persist_config off
    '';

    virtualHosts = {
      # 冒号开头 = 只在 :8443 上做 HTTP 虚拟主机，不启用自动 HTTPS
      ":8443" = {
        extraConfig = ''
          @notlan not remote_ip 127.0.0.1 192.168.31.0/24
          respond @notlan "forbidden" 403

          reverse_proxy 127.0.0.1:3080 {
            # 必须保留原始 Host：DSH 的 /api 按 Host 判定来源，改写会全部 403
            header_up Host {host}
          }
        '';
      };
    };
  };
}
