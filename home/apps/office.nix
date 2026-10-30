# OnlyOffice Desktop（buildFHSEnv 沙箱）不读系统字体，只认 ~/.fonts 里的真实文件
# 且不跟随符号链接，所以这里把字体合并后复制成实体文件。
{ pkgs, lib, ... }:
let
  fontPackages = [
    pkgs.corefonts # Arial / Times New Roman 等默认模板字体
    pkgs.vista-fonts # Calibri / Cambria / Consolas
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-cjk-serif
    pkgs.wqy_zenhei
    pkgs.lxgw-wenkai
    pkgs.nur.repos.chillcicada.ttf-ms-win10-sc-sup
    pkgs.noto-fonts-color-emoji
  ];

  mergedFonts = pkgs.runCommand "onlyoffice-fonts" { } ''
    mkdir -p "$out"
    for p in ${toString fontPackages}; do
      find "$p/share/fonts" -type f \( -name '*.ttf' -o -name '*.otf' -o -name '*.ttc' \) \
        -exec ln -sf {} "$out/" \;
    done
  '';
in
{
  home.activation.linkOnlyOfficeFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.fonts"
    cp -f ${mergedFonts}/*.ttf "$HOME/.fonts/" 2>/dev/null || true
    cp -f ${mergedFonts}/*.otf "$HOME/.fonts/" 2>/dev/null || true
    cp -f ${mergedFonts}/*.ttc "$HOME/.fonts/" 2>/dev/null || true
    ${pkgs.fontconfig}/bin/fc-cache -f "$HOME/.fonts" >/dev/null 2>&1 || true
  '';
}
