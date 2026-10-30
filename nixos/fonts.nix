# 字体（含 NUR 提供的 WPS / 微软字体）
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
      lxgw-wenkai
      nur.repos.chillcicada.ttf-ms-win10-sc-sup
      nur.repos.rewine.ttf-wps-fonts
      nur.repos.rewine.ttf-ms-win10
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
