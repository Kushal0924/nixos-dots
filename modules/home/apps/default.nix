# Home Manager applications, one module per app. Each is gated by its
# `dotfiles.apps.<name>.enable` switch (see ../../options.nix).
{
  inputs,
  ...
}:

{
  imports = [
    inputs.luciole.homeModules.default
    inputs.nhx.homeManagerModules.nhx
    ./bonfire-module.nix
    ./bonfire.nix
    ./fastfetch.nix
    ./helix.nix
    ./luciole.nix
    ./microfetch.nix
    ./mime.nix
    ./nautilus.nix
    ./vscode.nix
  ];
}
