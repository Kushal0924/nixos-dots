# Bonfire is a locally served new-tab page that follows the Noctalia palette.
# Point a new-tab override (e.g. New Tab Override) at http://127.0.0.1:8420/.
{
  lib,
  osConfig,
  ...
}:

lib.mkIf osConfig.dotfiles.apps.bonfire.enable {
  programs.bonfire = {
    enable = true;
    template.backend = "noctalia";
  };
}
