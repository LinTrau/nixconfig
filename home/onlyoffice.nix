# home/onlyoffice.nix
# OnlyOffice（buildFHSEnv 沙箱）只扫描 /usr/share/fonts 和 ~/.local/share/fonts 里的字体，
# 系统字体目录（/run/current-system/sw/share/fonts）它看不到，所以只剩它自带的 noto-fonts-cjk-sans。
# 参考官方 NixOS Wiki「ONLYOFFICE」页：把要用的字体软链进 ~/.local/share/fonts 即可。

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
  # 把合并后的字体软链到 ~/.local/share/fonts，OnlyOffice 就能看到
  home.file.".local/share/fonts" = {
    source = mergedFonts;
    recursive = true;
  };

  # 重新生成字体缓存，让 fontconfig（其他应用）也能识别这些字体
  home.activation.refreshFontCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.fontconfig}/bin/fc-cache -f "$HOME/.local/share/fonts" >/dev/null 2>&1 || true
  '';
}
