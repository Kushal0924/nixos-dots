{
  pkgs,
  ...
}:

{
  fonts.packages = with pkgs; [
    annotation-mono
    nerd-fonts.departure-mono
    nerd-fonts.jetbrains-mono
    noto-fonts-color-emoji
  ];
}
