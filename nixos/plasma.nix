# KDE Plasma 桌面环境系统级配置（SDDM + Plasma 6）
_:

{
  services = {
    xserver = {
      enable = true;

      videoDrivers = [
        "modesetting"
        "nvidia"
      ];

      xkb = {
        layout = "cn";
        variant = "";
      };
    };

    desktopManager.plasma6.enable = true;

    displayManager.sddm = {
      enable = true;
      theme = "breeze";
      wayland.enable = true;
      enableHidpi = true;
      autoNumlock = true;
    };
  };
}
