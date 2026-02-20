{ config, pkgs, inputs, lib, ... }:
{
  home.username = "scil";
  home.homeDirectory = "/home/scil";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

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


    sweet
    sweet-nova
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

  # Git 配置
  programs.git = {
    enable = true;
    settings.user.name = "LinTrau";
    settings.user.email = "eddyjarnaginbzw15@gmail.com";
    signing.key = "114FF4118D3C886A";
    signing.signByDefault = true;
  };

  systemd.user.services.yakuake = {
  Unit = {
    Description = "Yakuake drop-down terminal";
    After = [ "graphical-session.target" ];
    PartOf = [ "graphical-session.target" ];
  };
  Service = {
    ExecStart = "${pkgs.kdePackages.yakuake}/bin/yakuake";
    Restart = "on-failure";
  };
  Install = {
    WantedBy = [ "graphical-session.target" ];
  };
};

  programs.zsh = {
  enable = true;
  enableCompletion = true;
  autosuggestion.enable = true; 
  syntaxHighlighting.enable = true; 
  oh-my-zsh = {
    enable = true;
    plugins = [ "git" "sudo" ];
  };
  plugins = [
    {
      name = "powerlevel10k";
      src = pkgs.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }
  ];
  initContent = ''
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  '';
  };

}
