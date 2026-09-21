# Home Manager 用户软件包
{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # 基础工具
    fastfetch
    piper
    p7zip

    # 应用程序
    android-tools
    obs-studio
    mpv
    telegram-desktop
    rustdesk
    # comfyui 用官方 CUDA 预编译 wheel 版本（utensils/comfyui-nix 的 #cuda 输出）
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
    #openfoam-org
    paraview
    #freecad
    teamspeak6-client
    element-desktop
    scrcpy
    thunderbird
    onlyoffice-desktopeditors
    kdePackages.okular
    zotero

    # 主题

    # KDE 应用（已删：yakuake / spectacle / kpat / discover / supergfxctl-plasmoid / sddm-kcm）
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
  ];

  home.sessionVariables = {
    LD_LIBRARY_PATH = /run/current-system/sw/share/nix-ld/lib;
    JAVA_HOME = "${pkgs.jdk}";
    XDG_CURRENT_DESKTOP = "niri";
  };

  # ComfyUI 启动入口：启动服务并自动打开浏览器
  xdg.desktopEntries.comfyui = {
    name = "ComfyUI";
    genericName = "AI 图像生成";
    comment = "节点式 AI 图像生成工作流";
    # 全局 LD_LIBRARY_PATH(旧 glibc)会破坏 comfy-ui(新 glibc)，运行时清除它
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
