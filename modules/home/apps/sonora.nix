# Sonora music streaming client, from the sonora flake input.
{
  lib,
  osConfig,
  ...
}:

lib.mkIf osConfig.dotfiles.apps.sonora.enable {
  programs.sonora.enable = true;
}
