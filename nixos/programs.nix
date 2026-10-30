# 系统级程序、本地化与软件包
{ pkgs, ... }:

{
  time.timeZone = "Asia/Shanghai";

  i18n = {
    defaultLocale = "zh_CN.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
    };

    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        kdePackages.fcitx5-qt
        qt6Packages.fcitx5-chinese-addons
        fcitx5-material-color
        fcitx5-nord
      ];
    };
  };

  programs = {
    nushell.enable = true;

    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-qt;
      enableSSHSupport = true;
    };

    direnv.enable = true;
    partition-manager.enable = true;

    appimage = {
      enable = true;
      binfmt = true;
    };

    xwayland.enable = true;
    kdeconnect.enable = true;
    gamemode.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      package = pkgs.steam.override {
        extraPkgs = p: [ p.kdePackages.breeze ];
      };
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libadwaita
        gtk4
        glib
        pango
        cairo
        gdk-pixbuf
        atk
        harfbuzz
        fribidi
        gobject-introspection
        libGL
        libGLU
        libx11
        libxext
        stdenv.cc.cc.lib
        graphene
        wayland
        libxkbcommon
        libxshmfence
        pipewire
      ];
    };

    virt-manager.enable = true;
  };

  services.gvfs.enable = true;

  environment = {
    # 登记到 /etc/shells，否则 PAM 的 pam_shells / chsh 会拒绝 nushell
    shells = [ pkgs.nushell ];

    systemPackages = with pkgs; [
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
      dnsutils

      cudaPackages.cudatoolkit
      cudaPackages.cudnn

      python3
      python3Packages.pip
      python3Packages.virtualenv
    ];

    variables.CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
  };
}
