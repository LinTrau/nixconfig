# 系统级程序配置
{ pkgs, ... }:

{
  programs = {
    zsh.enable = true;

    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-qt;
      enableSSHSupport = true;
    };

    direnv.enable = true;
    partition-manager.enable = true;

    kde-pim = {
      enable = true;
      kmail = true;
      kontact = true;
    };

    appimage = {
      enable = true;
      binfmt = true;
    };

    xwayland.enable = true;
    kdeconnect.enable = true;

    clash-verge = {
      enable = true;
      autoStart = true;
      serviceMode = true;
    };

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
        stdenv.cc.cc.lib
        graphene
        wayland
        libxkbcommon
        libxshmfence
      ];
    };
  };

  security.soteria.enable = true;
  services.gvfs.enable = true;
}
