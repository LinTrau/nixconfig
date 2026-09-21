# lanzaboote（Secure Boot）接线
#
# 模块本身由 flake.nix 注入，这里只放配置内容，
# 免得安全启动的开关散落在 flake.nix 里。
# lanzaboote 会强制覆盖 systemd-boot，见 ./default.nix 的说明。

{ pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.sbctl ];
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
