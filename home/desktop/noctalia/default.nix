# Noctalia：顶栏 / 启动器 / 通知 / 会话 / 壁纸 / 锁屏 / 剪贴板
# 配色为磁带未来主义：琥珀 #E8A33D / 录音带棕 #241C16 / 面板棕 #3A2C23 / 铬灰 #8A8580 / 米白 #F0E6D2
{ pkgs, inputs, ... }:

{
  # class=homeManager 的模块只能从 home 树 import；inputs 由 flake.nix 的 extraSpecialArgs 注入
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    package = pkgs.noctalia;

    settings = {
      shell = {
        font_family = "JetBrainsMono Nerd Font";
        panel.transparency_mode = "glass";
      };

      theme = {
        mode = "dark";
        source = "custom";
        custom_palette = "CassetteFuturism";
      };

      wallpaper = {
        enabled = true;
        fill_mode = "crop";
        default.path = "/home/scil/cassette-futurism.jpg";
      };

      bar.main = {
        position = "top";
        thickness = 34;
        background_opacity = 0.55;
        radius = 6;
        margin_ends = 8;
        margin_edge = 8;
        start = [
          "launcher"
          "workspaces"
        ];
        center = [ "clock" ];
        end = [
          "h465855hgg/lyrics:lyrics"
          "network"
          "battery"
          "volume"
          "tray"
          "notifications"
          "control-center"
          "session"
        ];
      };

      widget.clock.format = "  {:%H:%M}  {:%m-%d}";

      plugins = {
        enabled = [ "h465855hgg/lyrics" ];
        auto_update = "all";
      };
    };

    # 写入 ~/.config/noctalia/palettes/CassetteFuturism.json
    customPalettes.CassetteFuturism = {
      dark = {
        mPrimary = "#E8A33D";
        mOnPrimary = "#241C16";
        mSecondary = "#B08968";
        mOnSecondary = "#241C16";
        mTertiary = "#6E8FA3";
        mOnTertiary = "#F0E6D2";
        mError = "#D1453C";
        mOnError = "#F0E6D2";
        mSurface = "#241C16";
        mOnSurface = "#F0E6D2";
        mSurfaceVariant = "#3A2C23";
        mOnSurfaceVariant = "#8A8580";
        mOutline = "#8A8580";
        mShadow = "#000000";
        mHover = "#4A3A2C";
        mOnHover = "#F0E6D2";
        terminal = {
          background = "#241C16";
          foreground = "#F0E6D2";
          cursor = "#E8A33D";
          cursorText = "#241C16";
          selectionBg = "#3A2C23";
          selectionFg = "#F0E6D2";
          normal = {
            black = "#241C16";
            red = "#D1453C";
            green = "#9CAF56";
            yellow = "#E8A33D";
            blue = "#6E8FA3";
            magenta = "#B08968";
            cyan = "#8A8580";
            white = "#F0E6D2";
          };
          bright = {
            black = "#4A3A2C";
            red = "#E06C62";
            green = "#B7C878";
            yellow = "#F2B95E";
            blue = "#8FA9BD";
            magenta = "#C9A47E";
            cyan = "#A5A09A";
            white = "#FFF4E2";
          };
        };
      };
      light = {
        mPrimary = "#B97814";
        mOnPrimary = "#F0E6D2";
        mSecondary = "#8A5A2B";
        mOnSecondary = "#F0E6D2";
        mTertiary = "#4A6A7D";
        mOnTertiary = "#F0E6D2";
        mError = "#B3342C";
        mOnError = "#F0E6D2";
        mSurface = "#F0E6D2";
        mOnSurface = "#241C16";
        mSurfaceVariant = "#E2D6BE";
        mOnSurfaceVariant = "#5A5142";
        mOutline = "#8A8580";
        mShadow = "#3A2C23";
        mHover = "#E2D6BE";
        mOnHover = "#241C16";
      };
    };
  };
}
