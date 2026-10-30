{
  pkgs,
  ...
}:

{
  # Phone and camera access over MTP/PTP.
  services.gvfs.enable = true;

  environment.systemPackages = with pkgs; [
    celluloid
    ffmpegthumbnailer
    file
    imagemagick
    loupe
    nautilus
    pavucontrol
    poppler
    sushi
    unzip
    evince
  ];
}
