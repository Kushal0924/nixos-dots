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
      luciole = {
        enable = true;
      };
      microfetch = {
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
      vesktop = {
        enable = true;
      };
      vscode = {
        enable = true;
      };
      zapfast = {
        enable = true;
      };
    };
  };

  networking.hostName = "arrodes";

  time.timeZone = "Asia/Kolkata";
}
