# home/wlogout/default.nix
{ ... }:

{
  xdg.configFile."wlogout/layout".source = ./layout.json;
  xdg.configFile."wlogout/style.css".source = ./style.css;
}
