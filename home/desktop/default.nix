# 桌面用户态配置聚合入口
# 系统侧（包 / session / portal）在 nixos/desktop/ 下。

{ ... }:

{
  imports = [
    ./niri
    ./noctalia
  ];
}
