# 桌面会话（系统侧）
#
# 系统层只负责「让 niri 能成为可选会话」：包、session 注册、portal、polkit。
# noctalia 的 flake 输入只提供 home-manager 模块，全部用户态配置在
# home/desktop/noctalia/ 下，因此这里没有对应的系统模块。

{ ... }:

{
  imports = [
    ./niri # niri（liquid-glass 补丁版）
  ];
}
