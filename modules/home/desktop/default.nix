# Everything graphical that Home Manager manages: the Umbriel compositor
# config, the session shell, the default terminal and the window-button theme.
# Imported by ../default.nix behind `dotfiles.desktop`.
{
  imports = [
    ./umbriel
    ./noctalia.nix
    ./misc.nix
  ];
}
