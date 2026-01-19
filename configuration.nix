# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;

  hardware.graphics.enable = true;
  hardware.nvidia.open = false;
  hardware.nvidia.modesetting.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      libva-utils
      vulkan-tools
      libvdpau
      libglvnd
    ];
  hardware.nvidia-container-toolkit.enable = true;
  # Regular Docker
  virtualisation.docker.daemon.settings.features.cdi = true;
  # Rootless
  virtualisation.docker.rootless.daemon.settings.features.cdi = true;

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
      };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";  
  };

  virtualisation.docker.enable = true;

  services.xserver.videoDrivers = ["modesetting" "nvidia"];

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true; 
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["hid_apple.fnmode=2"];

  boot = {
    extraModulePackages = with config.boot.kernelPackages;
    [v4l2loopback];
    extraModprobeConfig = ''options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1 '';
  };

  networking.hostName = "Scil-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = ["Mihomo"];
    checkReversePath = false;
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
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

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk 
      kdePackages.fcitx5-qt
      qt6Packages.fcitx5-chinese-addons
      fcitx5-material-color 
      fcitx5-nord
    ]; 
    #fcitx5.waylandFrontend = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "cn";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.scil = {
    isNormalUser = true;
    description = "scil";
    extraGroups = [ "networkmanager" "wheel" "docker" "gamemode" "adbusers" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = ["ventoy-qt5-1.1.07"];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    sbctl
    vim
    zed-editor
    unrar_6
    git
    gnupg
    wget
    nvtopPackages.nvidia
    noto-fonts
    fira-code
    lshw
    asusctl
    wineWowPackages.waylandFull
    winetricks
    blesh
    xsettingsd
    pinentry-curses
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

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      theme = "breeze";
      wayland.enable = true;
      enableHidpi = true;
      autoNumlock = true;
    };
  };

  programs.direnv.enable = true;
  programs.partition-manager.enable = true;
  programs.kde-pim = {
    enable = true;
    kmail = true;
    kontact = true;
  };

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  system.stateVersion = "25.05"; 

  security.soteria.enable = true;
  services.gvfs.enable = true;

  programs.xwayland.enable = true;
  programs.kdeconnect.enable = true;
  programs.clash-verge.enable = true;	
  programs.clash-verge.autoStart = true;
  programs.clash-verge.serviceMode = true;
  programs.gamemode.enable = true;

  security.doas = {
    enable = true;
    extraRules = [{
      users = [ "scil" ];
      noPass = true;
      keepEnv = true;
    }];
  };


  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    package = pkgs.steam.override {
      extraPkgs = p:[p.kdePackages.breeze];
      };
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
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
    stdenv.cc.cc.lib
    graphene
    wayland
    libxkbcommon
    libxshmfence
  ];

  services.asusd.enable = true;
  services.fwupd.enable = true;
  #services.ollama = {
  #  enable = true;
  #  loadModels = ["gpt-oss:20b" "deepseek-r1:32b" "gemma3:27b"];
  #  package = pkgs.ollama-cuda;
  #};
  services.ratbagd.enable = true;

  services.xrdp = {
    defaultWindowManager = "startplasma-x11";
    enable = true;
    openFirewall = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "scil" ];
  virtualisation.virtualbox.host.enableExtensionPack = true;

  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      wqy_zenhei
      hack-font
      source-code-pro
      jetbrains-mono
      lxgw-wenkai
      cascadia-code
    ];

    fontconfig = {
      antialias = true;
      hinting.enable = true;
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = ["lxgw-wenkai" "Noto Sans CJK SC" "DejaVu Sans Mono"];
        sansSerif = ["lxgw-wenkai" "Noto Sans CJK SC" "DejaVu Sans"];
        serif = ["lxgw-wenkai" "Noto Sans CJK SC" "DejaVu Serif"];
      };
    };
  };
}
