{
  lib,
  osConfig,
  ...
}:

lib.mkIf osConfig.dotfiles.desktop.enable {
  programs.umbriel.settings = {
    general = {
      show_cheatsheet = false;
      focus_on_activate = true;
    };

    include.optional.files = [
      "noctalia.toml"
    ];

    output."eDP-1" = {
      mode = "1920x1080@60";
      scale = 1.33;
      workspace_axis = "horizontal";
      workspaces = [
        "一"
        "二"
        "三"
        "四"
        "五"
      ];
    };

    appearance = {
      prefer_no_csd = true;

      border_width = 2;
      outer_border_width = 4;

      corner_radius = 10;

      shadow.enabled = false;
      drag_opacity = 1;

      title_bar = {
        mode = "forced";
        button_position = "left";
        button_corner_radius = 2;
        font = "Annotation Mono 10";
      };

      blur = {
        enabled = true;
        optimized = true;
        passes = 3;
        radius = 5;
        noise = 0.03;
        brightness = 0.9;
        contrast = 0.9;
        saturation = 1.1;
      };
    };

    layout = {
      mode = "floating";
      gap = 14;

      struts = {
        left = 0;
        right = 0;
        top = 0;
        bottom = 0;
      };

      extent_presets = [
        0.33333
        0.95
        0.66667
      ];

      scrolling = {
        default_extent_fraction = 0.95;
        center_focused = "always";
        center_underfull_strip = true;
      };
    };

    input = {
      keyboard = {
        layout = "us";
        variant = "";
        repeat_delay = 600;
        repeat_rate = 25;
        track_layout = "global";
      };

      touchpad = {
        disable_while_typing = true;
        tap = true;
        natural_scroll = true;
      };

      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 24;
      };
    };

    environment = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "gtk3";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      XCURSOR_THEME = "Bibata-Modern-Ice";
      XCURSOR_SIZE = "24";
    };
  };
}
