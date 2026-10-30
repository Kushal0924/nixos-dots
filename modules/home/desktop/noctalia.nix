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

      # The bar asks the compositor to blur behind it through the background
      # effect protocol; umbriel turns the blur off for ^noctalia-bar in its
      # layer rules, so stop asking for it at the source.
      bar.default.compositor_blur = false;

      # Workspace pills spell out the names 一..五 instead of 1..5. Kanji are
      # single characters, so the default max_label_chars = 1 shows them whole.
      widget.workspaces.label_source = "name";
    };
  };
}
