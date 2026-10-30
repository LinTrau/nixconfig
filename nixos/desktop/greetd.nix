# 登录器（greetd + ReGreet）。greeter 用户由模块自动创建，不要再手动定义
{ pkgs, ... }:

{
  services.displayManager.regreet = {
    enable = true;

    theme.name = "Adwaita";
    iconTheme.name = "Adwaita";
    cursorTheme.name = "Adwaita";
    font = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
      size = 14;
    };

    # ReGreet 默认浅色，米白字会看不清
    settings.GTK.application_prefer_dark_theme = true;

    # 磁带未来主义：CRT 琥珀 #E8A33D / 录音带棕 #241C16 / 面板棕 #3A2C23 / 铬灰 #8A8580 / 米白 #F0E6D2
    extraCss = ''
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
}
