# Umbriel, the only desktop session. Everything here exists only while
# `dotfiles.desktop` is on, so a host that does not ask for it never writes an
# umbriel config.
{
  lib,
  osConfig,
  ...
}:

{
  imports = [
    ./animations.nix
    ./autostart.nix
    ./keybinds.nix
    ./rules.nix
    ./settings.nix
  ];

  programs.umbriel = lib.mkIf osConfig.dotfiles.desktop.enable {
    enable = true;
    # The system module installs the package (from the umbriel flake input,
    # see modules/system/desktop.nix); adding it to home.packages too would
    # only shadow the system copy on PATH.
  };
}
