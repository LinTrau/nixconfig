# 登录器配置（greetd + ReGreet；Plasma 已移除）
# 注：greeter 用户由 services.greetd 模块自动创建，这里不要再定义，否则 isNormalUser/isSystemUser 冲突。

{ pkgs, ... }:

{
  services = {
    # 登录器用 greetd + ReGreet（替代 SDDM，Wayland 原生、无 Qt/KDE 依赖）
    # ReGreet 会自动启用 services.greetd、用 cage 承载、并自动创建 greeter 用户。
    displayManager.regreet = {
      enable = true;

      # 主题：磁带未来主义（琥珀 / 录音带棕 / 铬灰 / 米白）
      theme.name = "Adwaita";
      iconTheme.name = "Adwaita";
      cursorTheme.name = "Adwaita";
      font = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
        size = 14;
      };

      # 强制深色主题——ReGreet 默认浅色(白底)，导致登录框里米白字看不清。
      settings.GTK.application_prefer_dark_theme = true;

      extraCss = ''
        /* 磁带未来主义配色：CRT 琥珀 #E8A33D / 录音带棕 #241C16 / 面板棕 #3A2C23 / 铬灰 #8A8580 / 米白 #F0E6D2 */
        window, window.background, .background {
            background-color: #241C16;
        }
        label {
            color: #F0E6D2;
        }
        entry, password-entry {
            background-color: #3A2C23;
            color: #F0E6D2;
            caret-color: #E8A33D;
            border: 1px solid #8A8580;
            border-radius: 6px;
            padding: 6px 10px;
        }
        entry selection, password-entry selection {
            background-color: #E8A33D;
            color: #241C16;
        }
        entry:focus, password-entry:focus {
            border-color: #E8A33D;
        }
        button {
            background-color: #3A2C23;
            color: #F0E6D2;
            border: 1px solid #8A8580;
            border-radius: 6px;
            padding: 6px 14px;
        }
        button:hover {
            background-color: #4A3A2C;
            border-color: #E8A33D;
            color: #F0E6D2;
        }
        button.suggested-action {
            background-color: #E8A33D;
            color: #241C16;
            border-color: #E8A33D;
        }
        button.suggested-action:hover {
            background-color: #F2B95E;
        }
        combobox {
            background-color: #3A2C23;
            color: #F0E6D2;
        }
        combobox button {
            background-color: #3A2C23;
            color: #F0E6D2;
        }
      '';
    };
  };
}
