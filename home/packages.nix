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
    vscode
    prismlauncher
    osu-lazer-bin
    adwsteamgtk
    uwsm
    wlsunset
    file-roller
    brightnessctl
    protonplus
    splayer
    wemeet
    scilab-bin
    #openfoam-org
    paraview
    #freecad
    teamspeak6-client
    element-desktop
    scrcpy
    thunderbird
    mpris

    # 主题

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

  home.sessionVariables = {
    LD_LIBRARY_PATH = /run/current-system/sw/share/nix-ld/lib;
    JAVA_HOME = "${pkgs.jdk}";
  };

}
