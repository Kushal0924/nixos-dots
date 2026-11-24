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

  # ZapFast ships its desktop entry as "ZapFast"; call it "WhatsApp"
  # everywhere so the launcher and window names match the app it replaces.
  # symlinkJoin keeps the cached build and only swaps the desktop file.
  zapfast = pkgs.symlinkJoin {
    name = "zapfast";
    paths = [ pkgs.zapfast ];
    postBuild = ''
      rm $out/share/applications/zapfast.desktop
      substitute ${pkgs.zapfast}/share/applications/zapfast.desktop \
        $out/share/applications/zapfast.desktop \
        --replace-fail "Name=ZapFast" "Name=WhatsApp"
    '';
  };
in
{
  environment.systemPackages =
    lib.optional apps.foliate.enable pkgs.foliate
    ++ lib.optional apps.krita.enable pkgs.krita
    ++ lib.optional apps.libreoffice.enable pkgs.libreoffice
    ++ lib.optional apps.obsidian.enable pkgs.obsidian
    ++ lib.optional apps.vesktop.enable pkgs.vesktop
    ++ lib.optional apps.zapfast.enable zapfast;
}
