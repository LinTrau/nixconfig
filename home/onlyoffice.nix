# home/onlyoffice.nix
# OnlyOffice Desktop（buildFHSEnv 沙箱）不读系统字体，只认「自带字体 + ~/.fonts 里的真实文件」。
# 实测：~/.fonts 里的真实文件(Roboto/CustomTkinter)会出现在字体列表；软链进去的不显示。
#   * 系统字体(/run/current-system/sw/share/fonts) 它看不到
#   * ~/.local/share/fonts 它看不到
#   * ~/.fonts 里的符号链接它也不跟随
# 所以这里要把字体【复制成真实文件】放进 ~/.fonts。

{ pkgs, lib, ... }:
let
  # 需要让 OnlyOffice 能看到的字体包
  fontPackages = [
    pkgs.corefonts          # Arial / Times New Roman / Courier New / Verdana 等（OnlyOffice 默认模板字体）
    pkgs.vista-fonts        # Calibri / Cambria / Consolas 等 Windows 字体
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-cjk-serif
    pkgs.wqy_zenhei         # 文泉驿正黑
    pkgs.lxgw-wenkai        # 霞鹜文楷
    pkgs.nur.repos.chillcicada.ttf-ms-win10-sc-sup # 黑体/楷体/仿宋/等线（微软补充中文字体）
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
  # 把合并后的字体【复制成真实文件】到 ~/.fonts（cp 会跟随软链复制成实体字型文件）
  home.activation.linkOnlyOfficeFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.fonts"
    cp -f ${mergedFonts}/*.ttf "$HOME/.fonts/" 2>/dev/null || true
    cp -f ${mergedFonts}/*.otf "$HOME/.fonts/" 2>/dev/null || true
    cp -f ${mergedFonts}/*.ttc "$HOME/.fonts/" 2>/dev/null || true
    ${pkgs.fontconfig}/bin/fc-cache -f "$HOME/.fonts" >/dev/null 2>&1 || true
  '';
}
