# 引导加载程序、内核与 Secure Boot（lanzaboote 模块由 flake.nix 注入）
{ config, lib, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot = {
        # lanzaboote 接管引导；同一 attrset 内重复定义会报错，所以就地 mkForce 关闭
        enable = lib.mkForce false;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [
      "hid_apple.fnmode=2"
      "snd_intel_dspcfg.dsp_driver=3"
    ];

    extraModulePackages = [
      (config.boot.kernelPackages.v4l2loopback.overrideAttrs (old: {
        # 删掉 modules.dep 等索引文件，避免与内核自带模块冲突
        postInstall = (old.postInstall or "") + ''
          rm -f $out/lib/modules/*/modules.*
        '';
      }))
    ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  environment.systemPackages = [ pkgs.sbctl ];
}
