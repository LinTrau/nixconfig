# 硬件驱动、GPU 及虚拟化配置
{ pkgs, ... }:

{
  hardware = {
    enableAllFirmware = true;

    bluetooth.enable = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
        libva-utils
        vulkan-tools
        libvdpau
        libglvnd
      ];
    };

    nvidia = {
      open = false;
      modesetting.enable = true;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    nvidia-container-toolkit.enable = true;
  };

  # 注册 NVIDIA 驱动（niri/容器工具链/nvidia-container-toolkit 都需要）；不启用完整 X server
  services.xserver.videoDrivers = [ "nvidia" ];

  virtualisation = {
    docker = {
      daemon.settings.features.cdi = true;
      rootless.daemon.settings.features.cdi = true;
      enable = true;
    };

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        vhostUserPackages = [ pkgs.virtiofsd ];
      };
    };

  };

  users.extraGroups.vboxusers.members = [ "scil" ];
}
