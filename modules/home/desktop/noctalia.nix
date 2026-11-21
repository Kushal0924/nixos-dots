# Noctalia is the session shell: bar, launcher, notifications, control centre.
{
  lib,
  osConfig,
  ...
}:

lib.mkIf osConfig.dotfiles.desktop.enable {
  programs.noctalia = {
    enable = true;

    settings = {
      wallpaper = {
        enabled = true;
      };

      # Blur the shell: the bar asks the compositor for backdrop blur and stays
      # slightly translucent so Umbriel's blur is visible through it. Panels
      # use the glass transparency mode for the same effect.
      bar.default = {
        compositor_blur = true;
        background_opacity = 0.5;
      };

      shell.panel.transparency_mode = "glass";

      # Workspace pills spell out the names 一..五 instead of 1..5. Kanji are
      # single characters, so the default max_label_chars = 1 shows them whole.
      widget.workspaces.label_source = "name";
    };
  };
}
