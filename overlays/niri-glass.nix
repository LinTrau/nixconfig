# overlays/niri-glass.nix
#
# 把官方 niri 包"打补丁"成带液态玻璃 (liquid-glass) 效果的版本。
# 原理：zaroutt/Niri-glass 不是主题文件，而是对 niri 编译器源码的几个文件的替换
# （渲染管线 + shader + KDL 配置解析），所以这里用 overrideAttrs 在 postPatch
# 阶段把这几个文件覆盖进 nixpkgs 的 niri 源码里，再正常编译。
#
# !!! 必须手动确认的两件事 !!!
# 1. `rev` 目前设为 "main"——首次 `nix build` 会因为 sha256 不对而失败，
#    把报错里 "got: sha256-xxxx=" 的那行贴到下面 sha256 = "" 里即可（TOFU 模式）。
# 2. Niri-glass 只在作者本地某个 niri commit 上验证过（README 自称
#    "vibe coded project"），如果 nixpkgs 的 niri 版本差太多，
#    render_helpers/*.rs 可能对不上 niri 内部 API，编译会报错。
#    出问题时把 niri.version 锁定到跟 Niri-glass 更新时间接近的 nixpkgs 版本，
#    或者去 Niri-glass 的 issue 区确认兼容的 niri commit。

final: prev:
let
  niriGlassSrc = prev.fetchFromGitHub {
    owner = "zaroutt";
    repo = "Niri-glass";
    rev = "main"; # 建议换成具体 commit hash，避免上游一动你就要重新打补丁
    sha256 = "sha256-Dnwpynodfn1BmIvc+iXUGy55fm5Uootb6sD5LspDsQc="; # 见上方说明，首次构建后填入真实 hash
  };
in
{
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
}
