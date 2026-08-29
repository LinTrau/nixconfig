# Home Manager 配置入口（本文件必须放在仓库根目录，flake.nix 里用 `import ./home.nix` 引用它）
# 各功能子模块位于 ./home/ 目录下

{ inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default

    ./home/packages.nix
    ./home/git.nix
    ./home/zsh.nix
    ./home/niri # 顶栏/启动器/通知/会话/壁纸/锁屏统一由 noctalia 提供
    ./home/kitty.nix
    ./home/onlyoffice.nix # OnlyOffice 字体软链到 ~/.local/share/fonts
  ];

  home = {
    username = "scil";
    homeDirectory = "/home/scil";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}
