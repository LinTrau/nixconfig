# 用户软件包
{ pkgs, inputs, ... }:
{
  home = {
    packages = with pkgs; [
      fastfetch
      piper
      p7zip

      android-tools
      obs-studio
      mpv
      telegram-desktop
      rustdesk
      inputs.comfyui-nix.packages.${pkgs.stdenv.hostPlatform.system}.cuda
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
      splayer-next
      wemeet
      scilab-bin
      paraview
      teamspeak6-client
      element-desktop
      scrcpy
      thunderbird
      onlyoffice-desktopeditors
      kdePackages.okular
      folia-major
      pnpm

      kdePackages.kdenlive
      kdePackages.kcalc
      kdePackages.filelight
      kdePackages.isoimagewriter
      kdePackages.kmousetool
      kdePackages.kamoso
      kdePackages.krecorder
      kdePackages.kwave
      kdiff3
      kdePackages.sweeper
      kdePackages.ksystemlog

      # dsh web login
      (writeShellScriptBin "dsh-qr" ''
        url="$(journalctl --user -u dsh-web | grep -o 'http[^ ]*token=[^ ]*' | tail -1)"
        echo "$url"
        ${pkgs.qrencode}/bin/qrencode -t ANSIUTF8 "$url"
      '')
    ];

    sessionVariables = {
      LD_LIBRARY_PATH = /run/current-system/sw/share/nix-ld/lib;
      JAVA_HOME = "${pkgs.jdk}";
      XDG_CURRENT_DESKTOP = "niri";
    };
  };

  xdg.desktopEntries.comfyui = {
    name = "ComfyUI";
    genericName = "AI 图像生成";
    comment = "节点式 AI 图像生成工作流";
    # 全局 LD_LIBRARY_PATH 是旧 glibc，会破坏 comfy-ui，运行时清掉
    exec = "env -u LD_LIBRARY_PATH comfy-ui --open";
    icon = "applications-graphics";
    type = "Application";
    categories = [
      "Graphics"
      "Science"
      "Development"
    ];
    terminal = false;
    startupNotify = true;
  };
}
