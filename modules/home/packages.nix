{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    ani-cli
    awww
    btop
    fnm
    grc
    pokeget-rs
  ];
}
