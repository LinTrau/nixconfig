# NVIDIA PRIME offload 便捷入口
#
# 与 ./default.nix 的 hardware.nvidia.prime.offload 配套：
# 那边声明硬件/驱动侧，这里只提供命令行包装。
# 原先内联在 nixos/packages.nix 里，提出来是为了让「脚本」与「包列表」分开。

{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "nvidia-offload" ''
      #!/usr/bin/env bash
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '')
  ];
}
