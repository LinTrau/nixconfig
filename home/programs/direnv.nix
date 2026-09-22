# home/programs/direnv.nix
# direnv：进入含 .envrc 的目录时自动加载/卸载环境。
#
# 系统侧已在 nixos/programs.nix 开启（提供二进制 + bash 钩子）。
# nushell 不读 POSIX rc 文件，钩子必须在这里单独接线：
# enableNushellInteraction 会把 pre_prompt 钩子注入 programs.nushell.extraConfig，
# 其中包含 PATH 的字符串↔列表转换（nu 的 PATH 是列表，direnv 导出的是字符串）。

{ ... }:

{
  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
  };
}
