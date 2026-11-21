{
  lib,
  pkgs,
  osConfig,
  ...
}:

lib.mkIf osConfig.dotfiles.apps.microfetch.enable {
  home.packages = [ pkgs.microfetch ];
}
