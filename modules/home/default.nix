# Home Manager entry point for the user account.
{
  inputs,
  userName,
  ...
}:

{
  imports = [
    ./apps
    ./desktop
    ./packages.nix
    ./shell.nix

    # The desktop modules read `dotfiles.desktop` themselves; these two only
    # declare the options ./desktop/* fill in, so importing them is harmless
    # on a host without a desktop.
    inputs.noctalia.homeModules.default
    inputs.umbriel.homeModules.default
  ];

  home = {
    username = userName;
    homeDirectory = "/home/${userName}";

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.npm-global/bin"
    ];

    stateVersion = "26.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
