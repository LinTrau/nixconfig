# 系统级程序配置
{ pkgs, ... }:

{
  programs = {
    # nushell：全系统的交互 shell（zsh 已完全移除）
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

  security.soteria.enable = true;
  services.gvfs.enable = true;

  # 把 nushell 登记为「允许的登录 shell」。
  # 必须显式登记：users.users.*.shell 只会进 systemPackages，不会自动进
  # /etc/shells（systemShells 只包含它自己推导的项），而 PAM 的 pam_shells /
  # chsh 会按 /etc/shells 校验，否则换 shell 会失败。
  environment.shells = [ pkgs.nushell ];
}
