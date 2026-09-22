# 系统级软件包
# 注：nvidia-offload 包装脚本已移到 ../hardware/nvidia.nix
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
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
    pkg-config
    pinentry-qt
    usbutils
    quota
    rclone
    distrobox
    cargo
    julia
    chromium
    nodejs
    cmake
    ninja
    gcc
    gnumake
    mission-center

    cudaPackages.cudatoolkit
    cudaPackages.cudnn

    python3
    python3Packages.pip
    python3Packages.virtualenv
  ];

  environment.variables = {
    CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
  };
}
