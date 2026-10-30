# libvirt/QEMU with SPICE for a comfortable Windows guest.
{
  config,
  lib,
  pkgs,
  userName,
  ...
}:

lib.mkIf config.dotfiles.features.virtualization.enable {
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true; # Required for Windows 11 TPM
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

  environment.systemPackages = with pkgs; [
    spice
    spice-gtk
    spice-protocol
    virt-manager
    virt-viewer
    virtio-win
    win-spice
  ];

  # The groups belong to this feature, so they are created and granted here
  # instead of in users.nix: opting out leaves no dangling group references.
  users.groups.libvirtd = { };

  users.users.${userName}.extraGroups = [
    "kvm"
    "libvirtd"
  ];
}
