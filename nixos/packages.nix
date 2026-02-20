# 系统级软件包
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    zed-editor
    wget
    gnupg
    git
    unrar_6
    nvtopPackages.nvidia
    noto-fonts
    fira-code
    lshw
    asusctl
    wineWowPackages.waylandFull
    winetricks
    blesh
    xsettingsd
    pinentry-qt
    usbutils
    quota
    rclone

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
