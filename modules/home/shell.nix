{
  pkgs,
  ...
}:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fnm env --use-on-cd | source
      # So `nh os switch` needs no flake argument on this machine.
      set -gx NH_OS_FLAKE "$HOME/.dotfiles#infinix"
    '';
    plugins = [
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
    ];
  };
}
