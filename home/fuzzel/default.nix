# home/fuzzel.nix
{ ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
        terminal = "kitty";
        layer = "overlay";
        width = 40;
      };
      colors = {
        background = "241c16cc"; # 与 niri liquid-glass 面板呼应的半透明棕
        text = "f0e6d2ff";
        match = "e8a33dff"; # 匹配高亮用 CRT 琥珀
        selection = "3a2c23ff";
        selection-text = "e8a33dff";
        border = "8a8580ff";
      };
      border.width = 2;
    };
  };
}
