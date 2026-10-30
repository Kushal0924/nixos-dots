{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    awww
    btop
    fnm
    grc
    pokeget-rs
    spicetify-cli
  ];
}
