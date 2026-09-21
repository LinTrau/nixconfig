# 用户账户配置
{ pkgs, ... }:

{
  users.users.scil = {
    isNormalUser = true;
    description = "scil";
    shell = pkgs.zsh;
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
