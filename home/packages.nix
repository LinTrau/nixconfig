# Home Manager 用户软件包
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # 基础工具
    fastfetch
    piper
    p7zip

    # 应用程序
    android-tools
    qq
    wechat
    obs-studio
    mpv
    libreoffice-qt6-fresh
    projectlibre
    telegram-desktop
    tmux
    gimp
    prismlauncher
    osu-lazer-bin
    adwsteamgtk
    ventoy-full-qt
    swaybg
    uwsm
    wlsunset
    file-roller
    brightnessctl

    julia-bin
    conda

    # 主题
    sweet
    sweet-nova

    # KDE 应用
    kdePackages.yakuake
    kdePackages.spectacle
    kdePackages.kdenlive
    kdePackages.kcalc
    kdePackages.filelight
    kdePackages.isoimagewriter
    kdePackages.kmousetool
    okteta
    kdePackages.kamoso
    kdePackages.krecorder
    kdePackages.kwave
    supergfxctl-plasmoid
    kdiff3
    kdePackages.sweeper
    kdePackages.ksystemlog
    kdePackages.sddm-kcm
    kdePackages.kpat
    kdePackages.discover
  ];
}
