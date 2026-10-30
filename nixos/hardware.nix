# 硬件描述、文件系统、驱动 / GPU 与虚拟化
# 前半段由 nixos-generate-config 生成（换硬件后重新生成再手动合并）
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd.availableKernelModules = [
      "vmd"
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/8c374745-96ef-4df3-8b8e-1e82290e5e10";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/D6B6-CACF";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    "/mnt/data" = {
      device = "/dev/disk/by-uuid/5cfbe7cb-fe7c-4c58-b705-97e91c14e649";
      fsType = "ext4";
      options = [ "defaults" "nofail" ];
    };

    # NTFS 不存 POSIX 属主，挂载时必须显式指定 uid/gid；系统里没有 gid 1000 的组，所以用 100(users)
    "/mnt/repos" = {
      device = "/dev/disk/by-uuid/84492B13C9323BB5";
      fsType = "ntfs";
      options = [
        "defaults"
        "nofail"
        "uid=1000"
        "gid=100"
        "umask=022"
        "x-systemd.automount" # 热插后首次访问自动挂载，不再经 udisks
        "x-systemd.device-timeout=5s"
      ];
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/4a82bc19-3dba-41b3-8e0b-a5c3188e3539"; }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    enableAllFirmware = true;
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    graphics = {
      enable = true;
      enable32Bit = true;
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

  # 只注册 NVIDIA 驱动，不启用完整 X server
  services.xserver.videoDrivers = [ "nvidia" ];

  virtualisation = {
    docker = {
      enable = true;
      daemon.settings.features.cdi = true;
      rootless.daemon.settings.features.cdi = true;
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

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "nvidia-offload" ''
      #!/usr/bin/env bash
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '')
  ];
}
