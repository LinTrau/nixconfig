# home/programs/nushell.nix
# nushell 作为唯一交互 shell，取代原来的 zsh + powerlevel10k。
# 对应系统侧：nixos/programs.nix 启用 programs.nushell，
#            nixos/security/users.nix 把登录 shell 指到 pkgs.nushell。
#
# 说明：补全 / 语法高亮 / 历史搜索在 nushell 里是**内建**能力，
# 不是 shell 插件，所以不需要 oh-my-zsh / zsh-syntax-highlighting 那一套；
# 这里通过 programs.nushell.settings + extraConfig 配置它们。
#
# 配色沿用原来的「磁带未来主义」主题（原 p10k 主题的配色）：
#   CRT 琥珀 #E8A33D / 录音带棕 #241C16 / 面板棕 #3A2C23 / 铬灰 #8A8580
#   米白 #F0E6D2 / 警示红 #D1453C / 橄榄绿 #9CAF56 / 冷蓝灰 #6E8FA3 / 浅棕 #B08968

{ pkgs, ... }:

{
  # ------------------------------------------------------------------
  # starship：提示符（左侧目录/git、右侧时间等），替代原 powerlevel10k
  # nix-your-shell：让 nix-shell / nix develop 在 nu 里也保持同一个 shell
  # 两者的 nushell 集成都会自动往 programs.nushell.extraConfig 注入 source，
  # 无需手写 source（nushell 的 source 是编译期解析，手写反而容易报错）。
  # ------------------------------------------------------------------
  programs.starship = {
    enable = true;

    presets = [ "gruvbox-rainbow" ];

    # 合并顺序：presets 先铺底、settings 后覆盖（同键 settings 赢）。
    # 所以这里只保留 preset 没有的键，左侧外观完全交给 preset：
    #   os 图标 / 用户名 / 目录 / git / 语言段 / 时间芯片（其 format 末尾内联 $time）
    # 被删掉的同名键：format / directory / git_branch / git_status / time
    # 以及 nix_shell（preset 的 format 里没有 $nix_shell，留着也永不渲染）。
    settings = {
      add_newline = false;
      command_timeout = 1000;

      # preset 没定义 character，保留你的琥珀 ❯（命令失败变红）
      character = {
        success_symbol = "[❯](bold #E8A33D)";
        error_symbol = "[❯](bold #D1453C)";
      };

      # 右侧只保留耗时。$time 不能放这里：preset 的 format 末尾已经内联了 $time，
      # 两处同时存在会把时间渲染两遍。
      right_format = "$cmd_duration";

      cmd_duration = {
        style = "#8A8580";
        min_time = 2000;
        format = "[$duration]($style) ";
      };
    };
  };

  programs.nix-your-shell = {
    enable = true;
    enableNushellIntegration = true;
    nix-output-monitor.enable = true; # nix build 时走 nom，输出更清爽
  };

  programs.nushell = {
    enable = true;

    # nushell 用 $env.config 这一个嵌套记录来配置；home-manager 会把下面的键
    # 逐条展开成 $env.config.<键路径> = <值>
    settings = {
      show_banner = false;
      use_ansi_coloring = true;
      use_kitty_protocol = true;
      highlight_resolved_externals = true;
      error_style = "fancy";
      edit_mode = "emacs";

      # 命令补全（内建）：Tab 补全 + 外部命令补全
      completions = {
        case_sensitive = false;
        quick = true;
        partial = true;
        algorithm = "prefix";
        external = {
          enable = true;
          max_results = 200;
        };
      };

      # 历史：跨会话共享、Ctrl-R 可搜索、落 sqlite
      history = {
        max_size = 100000;
        sync_on_enter = true;
        file_format = "sqlite";
        isolation = false;
      };

      # 表格显示：与 kitty 的等宽字体 / 透明背景搭配
      table = {
        mode = "rounded";
        index_mode = "never";
        show_empty = false;
      };
      filesize = {
        unit = "metric";
        show_unit = true;
      };
    };

    # 颜色/高亮与菜单需要写 nu 原生记录，放在这里比走 Nix 转换更直观可控。
    extraConfig = ''
      # ---- 语法高亮配色（nushell 内建高亮，等价于 zsh-syntax-highlighting）----
      # 注意：除 search_result 外，nushell 的颜色项都是字符串，不能写成 { fg = ...; }
      $env.config.color_config = {
        separator: "#8A8580"
        leading_trailing_space_bg: "#3A2C23"
        header: "#E8A33D"
        row_index: "#6E8FA3"
        empty: "#8A8580"
        bool: "#9CAF56"
        int: "#E8A33D"
        filesize: "#E8A33D"
        duration: "#E8A33D"
        range: "#B08968"
        float: "#E8A33D"
        string: "#F0E6D2"
        nothing: "#8A8580"
        binary: "#B08968"
        "cell-path": "#6E8FA3"
        record: "#F0E6D2"
        list: "#F0E6D2"
        block: "#8A8580"
        hints: "#8A8580"
        search_result: { fg: "#241C16", bg: "#E8A33D" }

        shape_directory: "#6E8FA3"
        shape_filepath: "#6E8FA3"
        shape_external: "#9CAF56"
        shape_external_resolved: "#9CAF56"
        shape_externalarg: "#F0E6D2"
        shape_literal: "#B08968"
        shape_operator: "#D1453C"
        shape_pipe: "#D1453C"
        shape_signature: "#9CAF56"
        shape_string: "#F0E6D2"
        shape_raw_string: "#F0E6D2"
        shape_string_interpolation: "#E8A33D"
        shape_datetime: "#E8A33D"
        shape_list: "#F0E6D2"
        shape_record: "#F0E6D2"
        shape_table: "#F0E6D2"
        shape_bool: "#9CAF56"
        shape_int: "#E8A33D"
        shape_float: "#E8A33D"
        shape_range: "#B08968"
        shape_block: "#8A8580"
        shape_closure: "#8A8580"
        shape_nothing: "#8A8580"
        shape_binary: "#B08968"
        shape_cellpath: "#6E8FA3"
        shape_variable: "#6E8FA3"
        shape_custom: "#F0E6D2"
        shape_flag: "#E8A33D"
        shape_globpattern: "#B08968"
        shape_internalcall: "#9CAF56"
        shape_keyword: "#E8A33D"
        shape_matching_brackets: "#E8A33D"
      }

      # ---- 补全菜单：Tab 弹列式菜单，方向键在菜单里移动 ----
      $env.config.menus = ($env.config.menus | append {
        name: completion_menu
        only_buffer_difference: false
        marker: "| "
        type: {
          layout: columnar
          columns: 4
          col_width: 20
          col_padding: 2
        }
        style: {
          text: "#F0E6D2"
          selected_text: { fg: "#241C16", bg: "#E8A33D" }
          description_text: "#8A8580"
        }
      })

      # ---- 编辑器：NixOS 的 environment.variables 只对 POSIX shell 生效，
      #      nushell 不读 /etc/profile，所以这里显式设置一次
      #      （PATH 由 PAM 的 /etc/pam/environment 提供，无需重复）----
      $env.EDITOR = "nvim"
      $env.PAGER = "less"
      $env.config.buffer_editor = "nvim"
    '';

    # 常用别名（沿用 zsh 时期的习惯）
    shellAliases = {
      ll = "ls -l";
      la = "ls -a";
      lal = "ls -la";
      g = "git";
      gs = "git status";
      gd = "git diff";
      gc = "git commit";
      gp = "git push";
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos#Scil-nixos --show-trace";
      nfu = "sudo nix flake update";
    };

    environmentVariables = {
      EDITOR = "nvim";
      PAGER = "less";
      JAVA_HOME = "${pkgs.jdk}";
      XDG_CURRENT_DESKTOP = "niri";
    };
  };
}
