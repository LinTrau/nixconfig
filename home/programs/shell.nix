# 终端工作环境：nushell + starship + direnv + kitty，共用同一套磁带未来主义配色
# 配色：琥珀 #E8A33D / 录音带棕 #241C16 / 面板棕 #3A2C23 / 铬灰 #8A8580
#       米白 #F0E6D2 / 警示红 #D1453C / 橄榄绿 #9CAF56 / 冷蓝灰 #6E8FA3 / 浅棕 #B08968
{ pkgs, ... }:

{
  programs = {
    starship = {
      enable = true;
      presets = [ "gruvbox-rainbow" ];

      # presets 先铺底、settings 后覆盖，所以这里只写 preset 缺的键
      settings = {
        add_newline = false;
        command_timeout = 1000;

        character = {
          success_symbol = "[❯](bold #E8A33D)";
          error_symbol = "[❯](bold #D1453C)";
        };

        # $time 已在 preset 的 format 末尾内联，放右侧会渲染两遍
        right_format = "$cmd_duration";

        cmd_duration = {
          style = "#8A8580";
          min_time = 2000;
          format = "[$duration]($style) ";
        };
      };
    };

    nix-your-shell = {
      enable = true;
      enableNushellIntegration = true;
      nix-output-monitor.enable = true;
    };

    nushell = {
      enable = true;

      # 26.11 起默认值改为 true，stateVersion 仍是 25.05，显式固定避免 warning
      loadSessionVariables = false;

      settings = {
        show_banner = false;
        use_ansi_coloring = true;
        use_kitty_protocol = true;
        highlight_resolved_externals = true;
        error_style = "fancy";
        edit_mode = "emacs";

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

        history = {
          max_size = 100000;
          sync_on_enter = true;
          file_format = "sqlite";
          isolation = false;
        };

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

      extraConfig = ''
        # 除 search_result 外，颜色项都是字符串而不是记录
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

        # Tab 弹出列式补全菜单
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

        # nushell 不读 /etc/profile，编辑器变量在这里单独设
        $env.EDITOR = "nvim"
        $env.PAGER = "less"
        $env.config.buffer_editor = "nvim"
      '';

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

    # 系统侧已开启 direnv（提供二进制 + bash 钩子）；nushell 不读 POSIX rc，
    # 钩子必须在这里接线，enableNushellIntegration 会注入 PATH 字符串↔列表转换。
    direnv = {
      enable = true;
      enableNushellIntegration = true;
    };

    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 12;
      };
      settings = {
        background_opacity = "0.75"; # 配合 niri 的 liquid-glass 透出下层
        background = "#241C16";
        foreground = "#F0E6D2";
        cursor = "#E8A33D";
        selection_background = "#3A2C23";
        color0 = "#241C16";
        color1 = "#D1453C";
        color2 = "#9CAF56";
        color3 = "#E8A33D";
        color4 = "#6E8FA3";
        color5 = "#B08968";
        color6 = "#8A8580";
        color7 = "#F0E6D2";
      };
    };
  };

  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono # kitty / noctalia 的等宽字体，缺了会回退到 CJK 字体
  ];
}
