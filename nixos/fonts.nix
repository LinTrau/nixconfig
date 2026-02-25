# 字体配置
{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      wqy_zenhei
      hack-font
      source-code-pro
      #jetbrains-mono
      lxgw-wenkai
      cascadia-code
    ];

    fontconfig = {
      antialias = true;
      hinting.enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "lxgw-wenkai"
          "Noto Sans CJK SC"
          "DejaVu Sans Mono"
        ];
        sansSerif = [
          "lxgw-wenkai"
          "Noto Sans CJK SC"
          "DejaVu Sans"
        ];
        serif = [
          "lxgw-wenkai"
          "Noto Sans CJK SC"
          "DejaVu Serif"
        ];
      };
    };
  };
}
