# Home Manager 配置入口
# 各功能模块位于 ./home/ 目录下

{ inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default

    ./home/packages.nix
    ./home/git.nix
    ./home/zsh.nix
    ./home/yakuake.nix
    ./home/niri # 顶栏/启动器/通知/会话/壁纸/锁屏统一由 noctalia 提供
    ./home/kitty.nix
  ];

  home = {
    username = "scil";
    homeDirectory = "/home/scil";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}
