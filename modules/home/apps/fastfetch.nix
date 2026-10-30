{
  lib,
  osConfig,
  ...
}:

lib.mkIf osConfig.dotfiles.apps.fastfetch.enable {
  programs.fastfetch.enable = true;
}
