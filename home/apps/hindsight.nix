# Hindsight 自托管记忆守护进程（coding-agent profile）
# 运行体仍由 uv 获取（上游无 Nix 包，依赖含内嵌 PostgreSQL 与本地 ML 模型），
# 这里只把启动脚本与 systemd 用户服务声明化。
# LLM 故障转移链：主 = 本机 Bonsai（llama-server :8080），备 = 智谱 glm-4.7-flash；
# embedding 走本机 embed-server（llama.cpp Qwen3-Embedding :8090，纯 CPU）。
# 密钥只存在 /home/scil/bonsai/api-key.txt 与 ~/.config/hindsight/llm.env，不进 Nix store。
{ pkgs, ... }:

let
  hindsightDaemon = pkgs.writeShellApplication {
    name = "hindsight-daemon";
    # 下面动态 source 的是运行期路径，shellcheck 无法静态检查
    excludeShellChecks = [ "SC1091" ];
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
      export HINDSIGHT_API_LLM_PROVIDER="''${HINDSIGHT_API_LLM_PROVIDER:-openai}"
      export HINDSIGHT_API_LLM_MODEL="''${HINDSIGHT_API_LLM_MODEL:-bonsai-2-27b}"
      export HINDSIGHT_API_LLM_BASE_URL="''${HINDSIGHT_API_LLM_BASE_URL:-http://127.0.0.1:8080/v1}"
      export HINDSIGHT_API_EMBEDDINGS_PROVIDER="''${HINDSIGHT_API_EMBEDDINGS_PROVIDER:-litellm-sdk}"
      export HINDSIGHT_API_EMBEDDINGS_LITELLM_SDK_MODEL="''${HINDSIGHT_API_EMBEDDINGS_LITELLM_SDK_MODEL:-openai/qwen3-embed}"
      export HINDSIGHT_API_EMBEDDINGS_LITELLM_SDK_API_BASE="''${HINDSIGHT_API_EMBEDDINGS_LITELLM_SDK_API_BASE:-http://172.17.0.1:8090/v1}"
      # litellm 的 openai/ 前缀强制要求 api_key，占位即可（embed-server 不校验）
      export HINDSIGHT_API_EMBEDDINGS_LITELLM_SDK_API_KEY="''${HINDSIGHT_API_EMBEDDINGS_LITELLM_SDK_API_KEY:-ollama}"
      export HINDSIGHT_API_PORT="''${HINDSIGHT_API_PORT:-9077}"

      if [ -f "$HOME/.config/hindsight/llm.env" ]; then
        . "$HOME/.config/hindsight/llm.env"
        export HINDSIGHT_API_LLM_API_KEY HINDSIGHT_API_LLM_1_API_KEY HINDSIGHT_API_LLM_2_API_KEY HINDSIGHT_API_EMBEDDINGS_LITELLM_SDK_API_KEY
      fi

      # uv 缓存里可能留着多个历史版本，旧的会静默退出，取最新修改的那个
      API_BIN="$(find "$HOME/.cache/uv/archive-v0" -maxdepth 3 -name hindsight-api -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2- || true)"
      if [ -n "$API_BIN" ] && [ -x "$API_BIN" ]; then
        API_CMD=("$API_BIN")
      else
        echo "uv 缓存中没有 hindsight-api，回退到 uvx hindsight-api@latest。" >&2
        API_CMD=(uvx "hindsight-api@latest")
      fi

      # 不能传 --daemon：它会 Popen 出 detached 子进程再 exit(0)，systemd 会判定服务结束。
      # 设 _HINDSIGHT_DAEMON_CHILD=1 走常驻前台分支，交给 systemd 托管。
      export _HINDSIGHT_DAEMON_CHILD=1

      cd "$HOME"
      # steam-run 补上 NixOS 缺失的 FHS 库（内嵌 PostgreSQL 需要 libzstd/libssl/lz4/krb5 等）
      exec steam-run "''${API_CMD[@]}" --port "$HINDSIGHT_API_PORT" --host 127.0.0.1
    '';
  };
in
{
  home.packages = [
    pkgs.uv
    hindsightDaemon
  ];

  systemd.user.services.hindsight = {
    Unit = {
      Description = "Hindsight self-hosted memory daemon (coding-agent)";
      Documentation = [ "https://hindsight.vectorize.io" ];
      After = [ "network.target" "embed-server.service" "bonsai.service" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${hindsightDaemon}/bin/hindsight-daemon";
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStartSec = 300;
      Environment = [
        "HINDSIGHT_API_LLM_PROVIDER=openai"
        "HINDSIGHT_API_LLM_MODEL=glm-4.7-flashX"
        "HINDSIGHT_API_LLM_BASE_URL=https://open.bigmodel.cn/api/paas/v4"
        "HINDSIGHT_API_LLM_EXTRA_BODY='{\"thinking\":{\"type\":\"disabled\"}}'"
        "HINDSIGHT_API_LLM_MAX_CONCURRENT=1"
        "HINDSIGHT_API_LLM_REASONING_EFFORT=low"
        "HINDSIGHT_API_REFLECT_MAX_CONTEXT_TOKENS=12000"
        "HINDSIGHT_API_EMBEDDINGS_PROVIDER=litellm-sdk"
        "HINDSIGHT_API_EMBEDDINGS_LITELLM_SDK_MODEL=openai/qwen3-embed"
        "HINDSIGHT_API_EMBEDDINGS_LITELLM_SDK_API_BASE=http://172.17.0.1:8090/v1"
        "HINDSIGHT_API_LLM_TIMEOUT=300"
        "HINDSIGHT_API_LLM_STRATEGY='{\"mode\":\"failover\"}'"
        "HINDSIGHT_API_LLM_1_PROVIDER=openai"
        "HINDSIGHT_API_LLM_1_MODEL=glm-4.7-flash"
        "HINDSIGHT_API_LLM_1_BASE_URL=https://open.bigmodel.cn/api/paas/v4"
        "HINDSIGHT_API_LLM_1_EXTRA_BODY='{\"thinking\":{\"type\":\"disabled\"}}'"
        "HINDSIGHT_API_LLM_2_PROVIDER=openai"
        "HINDSIGHT_API_LLM_2_MODEL=bonsai-2-27b"
        "HINDSIGHT_API_LLM_2_BASE_URL=http://127.0.0.1:8080/v1"
        "HINDSIGHT_API_REFLECT_WALL_TIMEOUT=1800"
        "HINDSIGHT_API_REFLECT_LLM_TIMEOUT=600"
        "HINDSIGHT_API_PORT=9077"
      ];
    };
    Install.WantedBy = [ "default.target" ];
  };
}
