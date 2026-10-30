# 账户、提权（doas）与授权（polkit）
{ pkgs, ... }:

{
  users.users.scil = {
    isNormalUser = true;
    description = "scil";
    shell = pkgs.nushell;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "gamemode"
      "adbusers"
    ];
  };

  security = {
    doas = {
      enable = true;
      extraRules = [
        {
          users = [ "scil" ];
          noPass = true;
          keepEnv = true;
        }
      ];
    };

    # Soteria 是 Wayland 下的 polkit 认证代理（文件管理器挂载磁盘弹的密码框就是它）。
    # udisks2 对内部磁盘 / fstab 设备默认要求 auth_admin_keep，下面放行本地活动会话里的
    # wheel 用户挂载与卸载。要恢复弹窗，删掉 polkit.extraConfig 即可。
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (subject.isInGroup("wheel") && subject.active &&
              (action.id == "org.freedesktop.udisks2.filesystem-mount" ||
               action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
               action.id == "org.freedesktop.udisks2.filesystem-mount-other-seat" ||
               action.id == "org.freedesktop.udisks2.filesystem-fstab" ||
               action.id == "org.freedesktop.udisks2.filesystem-unmount-others" ||
               action.id == "org.freedesktop.udisks2.encrypted-unlock")) {
            return polkit.Result.YES;
          }
        });
      '';
    };

    soteria.enable = true;
  };
}
