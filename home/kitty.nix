# home/kitty.nix
{ ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono";
      size = 12;
    };
    settings = {
      background_opacity = "0.75"; # 配合 niri 的 xray/liquid-glass 透出下层
      background = "#241C16";
      foreground = "#F0E6D2";
      cursor = "#E8A33D";
      selection_background = "#3A2C23";
      color0 = "#241C16";
      color1 = "#D1453C"; # red
      color2 = "#9CAF56"; # 橄榄绿，磁带外壳常见色
      color3 = "#E8A33D"; # amber
      color4 = "#6E8FA3"; # 冷调蓝灰，仅点缀
      color5 = "#B08968";
      color6 = "#8A8580";
      color7 = "#F0E6D2";
    };
  };
}
