{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    fetch
    wget
    spicetify-cli
  ];
}
