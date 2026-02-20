# 系统服务配置
_:

{
  services = {
    printing.enable = true;

    sunshine = {
      enable = true;
      autoStart = false;
      capSysAdmin = true;
      openFirewall = true;
    };

    asusd.enable = true;
    fwupd.enable = true;
    ratbagd.enable = true;

    xrdp = {
      enable = true;
      defaultWindowManager = "startplasma-x11";
      openFirewall = true;
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # ollama = {
    #   enable = true;
    #   loadModels = ["gpt-oss:20b" "deepseek-r1:32b" "gemma3:27b"];
    #   package = pkgs.ollama-cuda;
    # };
  };
}
