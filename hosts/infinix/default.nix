# Host entry point: this machine's hardware-specific modules plus the shared
# system and feature bundles.
#
# A host opts in to everything optional through the `dotfiles.*` switches
# declared in ../../modules/options.nix; whatever is not listed here stays off.
{
  _module.args.userName = "mordred";

  imports = [
    ./audio
    ./hardware-configuration.nix

    ../../modules/system
    ../../modules/features
  ];

  dotfiles = {
    desktop = {
      enable = true;
    };

    features = {
      browser = {
        enable = true;
      };
      flatpak = {
        enable = true;
      };
      gaming = {
        enable = true;
      };
      jupyter = {
        enable = true;
      };
      python = {
        enable = true;
      };
      virtualization = {
        enable = true;
      };
    };

    apps = {
      bonfire = {
        enable = true;
      };
      easyeffects = {
        enable = true;
      };
      fastfetch = {
        enable = true;
      };
      helix = {
        enable = true;
      };
      krita = {
        enable = true;
      };
      libreoffice = {
        enable = true;
      };
      mime = {
        enable = true;
      };
      nautilus = {
        enable = true;
      };
      obsidian = {
        enable = true;
      };
      sonora = {
        enable = true;
      };
      vesktop = {
        enable = true;
      };
      vscode = {
        enable = true;
      };
      whatsapp-electron = {
        enable = true;
      };
    };
  };

  networking.hostName = "arrodes";

  time.timeZone = "Asia/Kolkata";
}
