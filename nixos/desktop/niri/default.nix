# niri 会话（liquid-glass 补丁版）：包、会话注册、portal
{ pkgs, ... }:

let
  # Niri-glass 不是主题，而是替换 niri 的几个渲染相关源文件，所以这里在 postPatch
  # 阶段覆盖进 nixpkgs 的 niri 源码再编译。上游自称 vibe coded，nixpkgs 的 niri
  # 版本差太多时 render_helpers/*.rs 可能对不上内部 API，届时锁 niri 版本。
  niriGlassSrc = pkgs.fetchFromGitHub {
    owner = "zaroutt";
    repo = "Niri-glass";
    rev = "147c35b0c328220fb60e5fd184a2a8bdf17bebeb";
    sha256 = "sha256-0Mcq5cH2A7HPgMc8aAxy4M+XhZ1ps/ZMlUWWkKsrcC4=";
  };

  niriGlassOverlay = final: prev: {
    niri-glass = prev.niri.overrideAttrs (old: {
      pname = "niri-glass";

      postPatch = (old.postPatch or "") + ''
        echo "==> applying liquid-glass patch from zaroutt/Niri-glass"
        cp -f ${niriGlassSrc}/src/render_helpers/liquid_glass.rs      src/render_helpers/liquid_glass.rs
        cp -f ${niriGlassSrc}/src/render_helpers/background_effect.rs src/render_helpers/background_effect.rs
        cp -f ${niriGlassSrc}/src/render_helpers/framebuffer_effect.rs src/render_helpers/framebuffer_effect.rs
        cp -f ${niriGlassSrc}/src/render_helpers/xray.rs              src/render_helpers/xray.rs
        cp -f ${niriGlassSrc}/src/render_helpers/mod.rs               src/render_helpers/mod.rs
        cp -f ${niriGlassSrc}/src/render_helpers/shaders/mod.rs       src/render_helpers/shaders/mod.rs
        mkdir -p src/render_helpers/shaders
        cp -f ${niriGlassSrc}/src/render_helpers/shaders/clipped_surface.frag \
              src/render_helpers/shaders/clipped_surface.frag
        cp -f ${niriGlassSrc}/niri-config/src/appearance.rs niri-config/src/appearance.rs
      '';
    });
  };
in
{
  nixpkgs.overlays = [ niriGlassOverlay ];

  environment.systemPackages = with pkgs; [
    niri-glass
    xwayland-satellite
    wl-clipboard
    grim
    slurp
    playerctl
    brightnessctl
  ];

  # 自定义派生换了 pname，nixpkgs 的 niri 模块不会自动注册会话，这里手动补
  services.displayManager.sessionPackages = [ pkgs.niri-glass ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config.niri = {
      default = [
        "gnome"
        "gtk"
      ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
    };
    # 保持 1.17 之前「取第一个支持该接口的后端」的行为，抑制告警
    config.common.default = "*";
  };

  programs.dconf.enable = true;
}
