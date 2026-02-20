# Yakuake 下拉终端 systemd 用户服务
{ pkgs, ... }:

{
  systemd.user.services.yakuake = {
    Unit = {
      Description = "Yakuake drop-down terminal";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.kdePackages.yakuake}/bin/yakuake";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
