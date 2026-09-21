# 系统级软件包
# 注：nvidia-offload 包装脚本已移到 ../hardware/nvidia.nix
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
    distrobox
    cargo
    julia
    chromium
    python3
    nodejs
  ];
}
