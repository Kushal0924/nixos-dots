# The user account. Feature modules grant their own extra groups (see
# features/virtualization.nix), so this list stays valid on every host.
{
  pkgs,
  userName,
  ...
}:

{
  users.users.${userName} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = [ pkgs.tree ];
  };

  # fish is the login shell for every user, root included.
  programs.fish.enable = true;
}
