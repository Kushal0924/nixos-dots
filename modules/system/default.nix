# Everything that applies to any host: kernel and bootloader, Nix itself, the
# desktop session, system services, users, and the shared package sets.
{
  inputs,
  ...
}:

{
  imports = [
    # The greeter and Umbriel modules only declare options, so importing
    # them unconditionally is harmless; whether they run is decided by
    # ./desktop.nix.
    inputs.noctalia-greeter.nixosModules.default
    inputs.umbriel.nixosModules.default

    ./boot.nix
    ./desktop.nix
    ./fonts.nix
    ./home-manager.nix
    ./nix.nix
    ./packages
    ./services.nix
    ./users.nix
  ];

  nixpkgs.config.problems.handlers."gtk+".broken = "warn";

  system.stateVersion = "26.05";
}
