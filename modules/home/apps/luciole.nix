# Luciole file manager, from the luciole flake input.
{
  lib,
  osConfig,
  ...
}:

lib.mkIf osConfig.dotfiles.apps.luciole.enable {
  programs.luciole.enable = true;
}
