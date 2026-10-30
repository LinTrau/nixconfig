# Home Manager 配置入口（flake.nix 用 import ./home.nix 引用）
{ ... }:

{
  imports = [
    ./home/programs/git.nix
    ./home/programs/shell.nix

    ./home/desktop/niri
    ./home/desktop/noctalia

    ./home/apps/office.nix
    ./home/apps/hindsight.nix

    ./home/packages.nix
  ];

  home = {
    username = "scil";
    homeDirectory = "/home/scil";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}
