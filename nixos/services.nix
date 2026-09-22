# 系统服务配置
{ pkgs, ... }:

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

    xserver.videoDrivers = [ "nvidia" ];

    ollama = {
      enable = true;
      # nixpkgs 较新版本已弃用 services.ollama.acceleration，
      # 改为显式指定带 CUDA 支持的包（等价于原来的 acceleration = "cuda"）。
      package = pkgs.ollama-cuda;
      environmentVariables = {
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_KV_CACHE_TYPE = "q8_0";
        OLLAMA_CONTEXT_LENGTH = "32768";
        OLLAMA_KEEP_ALIVE = "30m";
      };
    };
  };
}
