# 用户账户配置
{ pkgs, ... }:

{
  users.users.scil = {
    isNormalUser = true;
    description = "scil";
    shell = pkgs.nushell; # 全系统统一用 nushell（原 zsh 已移除）
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "gamemode"
      "adbusers"
    ];
  };

  security.doas = {
    enable = true;
    extraRules = [
      {
        users = [ "scil" ];
        noPass = true;
        keepEnv = true;
      }
    ];
  };
}
