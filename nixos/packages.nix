# 系统级软件包
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    gnupg
    git
    unrar
    nvtopPackages.nvidia
    noto-fonts
    fira-code
    lshw
    asusctl
    wineWow64Packages.waylandFull
    winetricks
    blesh
    xsettingsd
    pinentry-qt
    usbutils
    quota
    rclone
    wpsoffice-cn
    distrobox

    (writeShellScriptBin "nvidia-offload" ''
      #!/usr/bin/env bash
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '')
  ];
}
