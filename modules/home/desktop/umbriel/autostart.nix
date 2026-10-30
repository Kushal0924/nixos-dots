{
  lib,
  osConfig,
  ...
}:

lib.mkIf osConfig.dotfiles.desktop.enable {
  programs.umbriel.settings.general.autostart = [ "noctalia" ];
}
