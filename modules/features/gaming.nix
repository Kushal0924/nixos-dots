# Steam (Millennium build), GameMode, and the driver support games need.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.dotfiles.features.gaming.enable {
  nixpkgs.overlays = [ inputs.millennium.overlays.default ];

  programs.steam = {
    enable = true;
    package = pkgs.millennium-steam;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    # Extra packages to make available inside Steam's FHS environment
    extraPackages = with pkgs; [
      gamescope
      mangohud
    ];
  };

  # Enable GameMode for performance optimizations on demand
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations Activated'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations Deactivated'";
      };
    };
  };

  # Essential drivers and graphics setup (32-bit driver support for games)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Kernel tuning for performance
  boot.kernel.sysctl = {
    # Increase memory map count for modern memory-heavy games (e.g., Starfield, Hogwarts Legacy)
    "vm.max_map_count" = 2147483642;
  };

  environment.systemPackages = with pkgs; [
    # Launchers & Compatibility Layers
    bottles
    lutris
    protonup-qt
    wineWow64Packages.staging
    winetricks

    # Performance & HUD Tools
    gamescope
    mangohud

    # System Utilities
    gparted
    pciutils
  ];

  # Controller support (Xbox, PlayStation, Nintendo Switch)
  hardware.xpadneo.enable = true; # Enhanced Xbox controller driver
}
