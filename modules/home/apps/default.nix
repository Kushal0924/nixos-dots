# Home Manager applications, one module per app. Each is gated by its
# `dotfiles.apps.<name>.enable` switch (see ../../options.nix).
{
  inputs,
  ...
}:

{
  imports = [
    inputs.sonora.homeModules.default
    inputs.nhx.homeManagerModules.nhx
    ./bonfire-module.nix
    ./bonfire.nix
    ./fastfetch.nix
    ./helix.nix
    ./mime.nix
    ./nautilus.nix
    ./sonora.nix
    ./vscode.nix
  ];
}
