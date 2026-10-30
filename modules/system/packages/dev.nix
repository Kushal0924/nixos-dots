{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    gcc
    git
    lazygit
    # nix CLI helper: `nh os switch`, `nh home build`, ...
    nh
    nodejs
    opencode

    devenv
  ];
}
