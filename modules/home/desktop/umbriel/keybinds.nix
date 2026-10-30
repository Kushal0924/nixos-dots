{
  lib,
  osConfig,
  ...
}:

lib.mkIf osConfig.dotfiles.desktop.enable {
  programs.umbriel.settings.keybinds = {
    # Session
    "Mod+Shift+Slash" = {
      action = "cheatsheet-toggle";
      repeat = false;
    };

    "Mod+Q" = {
      action = "window-close";
      repeat = false;
    };

    "Mod+Return" = {
      action = "spawn:kitty";
      repeat = false;
    };

    "Mod+B" = {
      action = "spawn:helium";
      repeat = false;
    };

    "Mod+E" = {
      action = "spawn:nautilus --new-window";
      repeat = false;
    };

    "Mod+G" = {
      action = "spawn:noctalia msg panel-toggle alexander/game-launcher:browser";
      repeat = false;
    };

    # Noctalia shell
    "Mod+Space" = {
      action = "spawn:noctalia msg panel-toggle launcher";
      repeat = false;
    };

    "Mod+S" = {
      action = "spawn:noctalia msg panel-toggle control-center";
      repeat = false;
    };

    "Mod+Comma" = {
      action = "spawn:noctalia msg settings-toggle";
      repeat = false;
    };

    "Mod+Shift+W" = {
      action = "spawn:noctalia msg panel-toggle wallpaper";
      repeat = false;
    };

    "XF86PowerOff" = {
      action = "spawn:noctalia msg panel-toggle session";
      repeat = false;
    };

    # Audio & brightness. Routed through Noctalia so its OSDs show, and repeat
    # while held; `allow_when_locked` keeps them working on the lock screen.
    "XF86AudioRaiseVolume" = {
      action = "spawn:noctalia msg volume-up";
      allow_when_locked = true;
    };

    "XF86AudioLowerVolume" = {
      action = "spawn:noctalia msg volume-down";
      allow_when_locked = true;
    };

    "XF86AudioMute" = {
      action = "spawn:noctalia msg volume-mute";
      allow_when_locked = true;
      repeat = false;
    };

    "XF86MonBrightnessUp" = {
      action = "spawn:noctalia msg brightness-up";
      allow_when_locked = true;
    };

    "XF86MonBrightnessDown" = {
      action = "spawn:noctalia msg brightness-down";
      allow_when_locked = true;
    };

    # Focus. Mod+Up/Down switch workspaces (niri's focus-workspace-up/down);
    # Mod+K/J move inside the column.
    "Mod+O" = {
      action = "overview-toggle";
      repeat = false;
    };

    "Mod+Left" = "workspace-previous";
    "Mod+H" = "window-focus-left";
    "Mod+Right" = "workspace-next";
    "Mod+L" = "window-focus-right";
    "Mod+Up" = "workspace-previous";
    "Mod+Down" = "workspace-next";
    "Mod+K" = "window-focus-up";
    "Mod+J" = "window-focus-down";
    "Mod+Home" = "column-focus-first";
    "Mod+End" = "column-focus-last";

    # Movement
    "Mod+Ctrl+Left" = "column-move-left";
    "Mod+Ctrl+H" = "column-move-left";
    "Mod+Ctrl+Right" = "column-move-right";
    "Mod+Ctrl+L" = "column-move-right";
    "Mod+Ctrl+Up" = "window-move-up";
    "Mod+Ctrl+K" = "window-move-up";
    "Mod+Ctrl+Down" = "window-move-down";
    "Mod+Ctrl+J" = "window-move-down";
    "Mod+Ctrl+Home" = "column-move-to-first";
    "Mod+Ctrl+End" = "column-move-to-last";

    "Mod+Shift+Left" = "output-focus-left";
    "Mod+Shift+Right" = "output-focus-right";
    "Mod+Shift+Up" = "output-focus-up";
    "Mod+Shift+Down" = "output-focus-down";

    "Mod+Shift+Ctrl+Left" = "column-move-to-output-left";
    "Mod+Shift+Ctrl+Right" = "column-move-to-output-right";
    "Mod+Shift+Ctrl+Up" = "column-move-to-output-up";
    "Mod+Shift+Ctrl+Down" = "column-move-to-output-down";

    "Mod+Shift+V" = {
      action = "window-focus-switch-floating";
      repeat = false;
    };

    # Workspaces
    "Mod+WheelDown" = {
      action = "workspace-next";
      cooldown_ms = 150;
    };

    "Mod+WheelUp" = {
      action = "workspace-previous";
      cooldown_ms = 150;
    };

    "Mod+Ctrl+WheelDown" = {
      action = "column-move-to-workspace-next";
      cooldown_ms = 150;
    };

    "Mod+Ctrl+WheelUp" = {
      action = "column-move-to-workspace-previous";
      cooldown_ms = 150;
    };

    "Alt+Tab" = "spawn:noctalia msg window-switcher hold";

    "Mod+WheelRight" = "window-focus-right";
    "Mod+WheelLeft" = "window-focus-left";
    "Mod+Ctrl+WheelRight" = "column-move-right";
    "Mod+Ctrl+WheelLeft" = "column-move-left";
    "Mod+Shift+WheelDown" = "window-focus-right";
    "Mod+Shift+WheelUp" = "window-focus-left";
    "Mod+Ctrl+Shift+WheelDown" = "column-move-right";
    "Mod+Ctrl+Shift+WheelUp" = "column-move-left";

    # Five workspaces, named 一..五 in settings.nix; 6..9 have no binds.
    "Mod+1" = "workspace-switch:1";
    "Mod+2" = "workspace-switch:2";
    "Mod+3" = "workspace-switch:3";
    "Mod+4" = "workspace-switch:4";
    "Mod+5" = "workspace-switch:5";

    "Mod+Ctrl+1" = "column-move-to-workspace:1";
    "Mod+Ctrl+2" = "column-move-to-workspace:2";
    "Mod+Ctrl+3" = "column-move-to-workspace:3";
    "Mod+Ctrl+4" = "column-move-to-workspace:4";
    "Mod+Ctrl+5" = "column-move-to-workspace:5";

    "Mod+Tab" = "workspace-previous";

    # Layout
    "Mod+C" = "column-center";

    "Mod+Minus" = "window-modify-primary-extent:-0.1";
    "Mod+Equal" = "window-modify-primary-extent:0.1";
    "Mod+Shift+Minus" = "window-modify-secondary-extent:-0.1";
    "Mod+Shift+Equal" = "window-modify-secondary-extent:0.1";

    "Mod+T" = {
      action = "window-toggle-floating";
      repeat = false;
    };

    "Mod+F" = {
      action = "window-toggle-maximize";
      repeat = false;
    };

    "Mod+Shift+F" = {
      action = "window-toggle-fullscreen";
      repeat = false;
    };

    "Mod+M" = {
      action = "window-toggle-maximize-to-edges";
      repeat = false;
    };

    # niri's expand-column-to-available-width.
    "Mod+Ctrl+F" = {
      action = "window-set-primary-extent:1.0";
      repeat = false;
    };

    # Screenshots, through Noctalia so its editor and output policy apply
    # (niri's own screenshot actions have no umbriel equivalent).
    "Ctrl+Shift+1" = {
      action = "spawn:noctalia msg screenshot-region";
      repeat = false;
    };

    "Ctrl+Shift+2" = {
      action = "spawn:noctalia msg screenshot-fullscreen";
      repeat = false;
    };
  };
}
