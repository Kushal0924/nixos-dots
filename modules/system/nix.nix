# Nix itself: flakes and unfree packages, plus direnv for per-project shells.
_: {
  nix.settings = {
    # Nix flakes and the `nix` CLI's modern commands.
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Noctalia's cachix binary cache. The noctalia and luciole inputs pin the
    # cachix branch and do not follow nixpkgs, so builds can hit this cache.
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  # Steam, VS Code, ...
  nixpkgs.config.allowUnfree = true;

  programs.direnv = {
    enable = true;
    loadInNixShell = true;
    nix-direnv.enable = true;
  };
}
