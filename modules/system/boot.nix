# Kernel and bootloader.
{
  pkgs,
  ...
}:

{
  # Newest stable kernel available in nixpkgs, rather than whatever the
  # `linux` alias points at.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
    };
  };
}
