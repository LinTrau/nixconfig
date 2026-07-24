# home/waybar.nix
{ ... }:

{
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 34;
      modules-left = [ "niri/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "battery" "tray" ];

      clock.format = "  {:%H:%M   %m-%d}"; # 磁带机数码管风格的间距

      battery = {
        format = "{icon}  {capacity}%";
        format-icons = [ "" "" "" "" "" ];
      };
    };
  };

  xdg.configFile."waybar/style.css".source = ./style.css;
}
