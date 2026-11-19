# System-wide GUI applications. Each is gated by its own
# `dotfiles.apps.<name>.enable` switch (see ../../options.nix).
{
  config,
  lib,
  pkgs,
  ...
}:

let
  apps = config.dotfiles.apps;
in
{
  environment.systemPackages =
    lib.optional apps.krita.enable pkgs.krita
    ++ lib.optional apps.libreoffice.enable pkgs.libreoffice
    ++ lib.optional apps.obsidian.enable pkgs.obsidian
    ++ lib.optional apps.vesktop.enable pkgs.vesktop
    ++ lib.optional apps.whatsapp-electron.enable pkgs.whatsapp-electron;
}
