# noctalia 的 home-manager 模块接线
#
# 由 flake.nix 的 extraSpecialArgs 注入 inputs。
# 注意：inputs.noctalia.homeModules.default 是 class="homeManager" 的模块，
# 只能从 home 树 import，不能放进 nixos/ 里（否则报 class 不匹配）。

{ inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];
}
