# Hindsight 自托管记忆守护进程（coding-agent profile）
#
# 运行体（hindsight-api）仍由 uv/uvx 获取——上游没有 Nix 包，且依赖里含
# pg0 内嵌 PostgreSQL、本地 ML 模型等，不适合用 nixpkgs 重打。
# 本模块只把「启动脚本 + systemd 用户服务」声明化，替代原先手工维护的：
#   ~/.hindsight/hindsight-daemon-service.sh
#   ~/.config/systemd/user/hindsight.service
#
# 密钥不写入 Nix store：启动时从 ~/.dsh/.credentials.yaml 读取 DEEPSEEK_API_KEY。
{ pkgs, ... }:

let
  hindsightDaemon = pkgs.writeShellApplication {
    name = "hindsight-daemon";
    runtimeInputs = with pkgs; [
      uv
      steam-run
      curl
      procps
      findutils
      gnugrep
      coreutils
    ];
    text = ''
      export HINDSIGHT_API_LLM_PROVIDER="''${HINDSIGHT_API_LLM_PROVIDER:-deepseek}"
      export HINDSIGHT_API_LLM_MODEL="''${HINDSIGHT_API_LLM_MODEL:-deepseek-flash}"
      export HINDSIGHT_API_PORT="''${HINDSIGHT_API_PORT:-9077}"

      # 从 dsh 凭据文件读取 DeepSeek key（若未显式提供）
      if [ -z "''${HINDSIGHT_API_LLM_API_KEY:-}" ]; then
        HINDSIGHT_API_LLM_API_KEY="$(grep -oP 'DEEPSEEK_API_KEY:\s*\K.*' "$HOME/.dsh/.credentials.yaml" 2>/dev/null | head -1 || true)"
        export HINDSIGHT_API_LLM_API_KEY
      fi

      # 取最近修改的 hindsight-api（uv 缓存里可能有多个历史版本，旧的会静默退出）
      API_BIN="$(find "$HOME/.cache/uv/archive-v0" -maxdepth 3 -name hindsight-api -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2- || true)"
      if [ -n "$API_BIN" ] && [ -x "$API_BIN" ]; then
        API_CMD=("$API_BIN")
      else
        echo "uv 缓存中没有 hindsight-api，回退到 uvx hindsight-api@latest。" >&2
        API_CMD=(uvx "hindsight-api@latest")
      fi

      # 关键：**不能**传 --daemon！hindsight-api 的 --daemon 会 Popen 一个
      # detached 子进程然后 sys.exit(0)，systemd Type=simple 会立刻判定服务已结束。
      # 正确做法是设 _HINDSIGHT_DAEMON_CHILD=1：走 child 分支，进程常驻前台，
      # 由 systemd 直接托管、跟踪、自动重启。
      export _HINDSIGHT_DAEMON_CHILD=1

      cd "$HOME"
      # steam-run 提供 NixOS 缺失的 FHS 动态库（内嵌 PostgreSQL 需要 libzstd/libssl/lz4/krb5 等）
      exec steam-run "''${API_CMD[@]}" --port "$HINDSIGHT_API_PORT" --host 127.0.0.1
    '';
  };
in
{
  # uv 之前是用 nix profile install 命令式装的，这里改为声明式提供
  home.packages = [
    pkgs.uv
    hindsightDaemon
  ];

  systemd.user.services.hindsight = {
    Unit = {
      Description = "Hindsight self-hosted memory daemon (coding-agent)";
      Documentation = [ "https://hindsight.vectorize.io" ];
      After = [ "network.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${hindsightDaemon}/bin/hindsight-daemon";
      Restart = "on-failure";
      RestartSec = 5;
      # daemon 本身有 --idle-timeout 0，这里给足冷启动时间
      TimeoutStartSec = 300;
      Environment = [
        "HINDSIGHT_API_LLM_PROVIDER=deepseek"
        "HINDSIGHT_API_LLM_MODEL=deepseek-flash"
        "HINDSIGHT_API_PORT=9077"
      ];
    };
    Install.WantedBy = [ "default.target" ];
  };
}
