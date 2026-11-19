# Optional capabilities a host opts into. Every module here is gated by its
# own `dotfiles.features.<name>.enable` switch (see ../../options.nix).
{
  imports = [
    ./browser.nix
    ./flatpak.nix
    ./gaming.nix
    ./jupyter.nix
    ./python.nix
    ./virtualization.nix
  ];
}
