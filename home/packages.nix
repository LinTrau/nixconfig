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
    telegram-desktop
    tmux
    gimp
    prismlauncher
    osu-lazer-bin
    adwsteamgtk
    swaybg
    uwsm
    wlsunset
    file-roller
    brightnessctl
    protonplus
    splayer
    wemeet
    blender
    bitwig-studio3
    scilab-bin
    #openfoam paraview
    freecad

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
