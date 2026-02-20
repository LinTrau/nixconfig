# Home Manager 配置入口
# 各功能模块位于 ./home/ 目录下

{ ... }:

{
  imports = [
    ./home/packages.nix
    ./home/git.nix
    ./home/zsh.nix
    ./home/yakuake.nix
  ];

  home = {
    username = "scil";
    homeDirectory = "/home/scil";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}
