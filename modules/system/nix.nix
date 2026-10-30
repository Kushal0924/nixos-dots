# Nix itself: flakes and unfree packages, plus direnv for per-project shells.
_: {
  # Nix flakes and the `nix` CLI's modern commands.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Steam, VS Code, ...
  nixpkgs.config.allowUnfree = true;

  programs.direnv = {
    enable = true;
    loadInNixShell = true;
    nix-direnv.enable = true;
  };
}
