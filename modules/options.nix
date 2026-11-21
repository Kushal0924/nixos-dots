# The contract between hosts and the modules they compose.
#
# Every optional module in this configuration reads one of the options declared
# here, so a host opts in (or out) by setting them in its own default.nix.
# Nothing is enabled by default: adding a host directory to `hosts/` gives you
# the required system modules only.
#
# The same options reach Home Manager through `osConfig`, so the modules in
# `modules/home/apps` are gated by the same switches as `modules/system`.
{
  lib,
  ...
}:

let
  feature = description: lib.mkEnableOption "the ${description} feature bundle";
  app = description: lib.mkEnableOption "the ${description} application";
in
{
  options.dotfiles = {
    # `modules/features` — capability bundles that bring their own services.
    features = {
      browser = {
        enable = feature "browser";
      };
      flatpak = {
        enable = feature "Flatpak";
      };
      gaming = {
        enable = feature "gaming";
      };
      jupyter = {
        enable = feature "jupyter";
      };
      python = {
        enable = feature "python";
      };
      virtualization = {
        enable = feature "virtualization";
      };
    };

    # GUI applications, split per app: `modules/home/apps` (Home Manager) and
    # `modules/system/packages/apps` (system-wide).
    apps = {
      bonfire = {
        enable = app "Bonfire";
      };
      fastfetch = {
        enable = app "fastfetch";
      };
      helix = {
        enable = app "Helix";
      };
      krita = {
        enable = app "Krita";
      };
      libreoffice = {
        enable = app "LibreOffice";
      };
      mime = {
        enable = app "MIME type defaults";
      };
      nautilus = {
        enable = app "Nautilus";
      };
      obsidian = {
        enable = app "Obsidian";
      };
      sonora = {
        enable = app "Sonora";
      };
      spotify = {
        enable = app "Spotify";
      };
      vesktop = {
        enable = app "Vesktop";
      };
      vscode = {
        enable = app "VS Code";
      };
      whatsapp-electron = {
        enable = app "WhatsApp Electron";
      };
    };

    # The Umbriel graphical session: compositor, login screen, session shell
    # and the Home Manager desktop modules. Turn this off for a headless host.
    desktop = {
      enable = lib.mkEnableOption "the Umbriel graphical desktop session";
    };
  };
}
