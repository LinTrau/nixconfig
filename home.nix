# Home Manager 配置入口（本文件必须放在仓库根目录，flake.nix 里用 `import ./home.nix` 引用它）
# 各功能子模块位于 ./home/ 目录下，按职责分目录，与 ./nixos/ 对称：
#   desktop/   桌面外观与会话助手（niri / noctalia）
#   programs/  命令行程序配置（git / nushell）
#   apps/      单个应用的适配（kitty / onlyoffice / hindsight）

{ ... }:

{
  imports = [
    ./home/programs
    ./home/desktop
    ./home/apps

    ./home/packages.nix
  ];

  home = {
    username = "scil";
    homeDirectory = "/home/scil";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}
