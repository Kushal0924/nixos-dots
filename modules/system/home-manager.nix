# Home Manager is managed from NixOS so `nixos-rebuild` also switches the
# user's environment.
{
  inputs,
  userName,
  ...
}:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    # Noctalia rewrites gtk.css at runtime, so backups would otherwise
    # clobber-block every activation.
    overwriteBackup = true;
    extraSpecialArgs = {
      inherit inputs userName;
    };
    users.${userName} = ../home;
  };
}
