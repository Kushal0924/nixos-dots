# Home Manager applications, one module per app. Each is gated by its
# `dotfiles.apps.<name>.enable` switch (see ../../options.nix).
#
# The nix-webapps module is imported here instead of from ./webapps.nix,
# because `imports` cannot live inside a conditional module.
{
  inputs,
  ...
}:

{
  imports = [
    inputs.nix-webapps.homeManagerModules.default
    inputs.sonora.homeModules.default
    inputs.nhx.homeManagerModules.nhx
    ./bonfire-module.nix
    ./bonfire.nix
    ./easyeffects.nix
    ./fastfetch.nix
    ./helix.nix
    ./mime.nix
    ./nautilus.nix
    ./sonora.nix
    ./vscode.nix
    ./webapps.nix
  ];
}
