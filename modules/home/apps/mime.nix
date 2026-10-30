{
  lib,
  osConfig,
  ...
}:

lib.mkIf osConfig.dotfiles.apps.mime.enable {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Video
      "video/x-matroska" = [ "io.github.celluloid_player.Celluloid.desktop" ];
      "video/mp4" = [ "io.github.celluloid_player.Celluloid.desktop" ];
      "video/webm" = [ "io.github.celluloid_player.Celluloid.desktop" ];
      "video/ogg" = [ "io.github.celluloid_player.Celluloid.desktop" ];
      "video/x-ogm" = [ "io.github.celluloid_player.Celluloid.desktop" ];
      "video/x-ogm+ogg" = [ "io.github.celluloid_player.Celluloid.desktop" ];
      "video/x-msvideo" = [ "io.github.celluloid_player.Celluloid.desktop" ];
      "video/x-flv" = [ "io.github.celluloid_player.Celluloid.desktop" ];
      "video/quicktime" = [ "io.github.celluloid_player.Celluloid.desktop" ];
      "video/x-ms-wmv" = [ "io.github.celluloid_player.Celluloid.desktop" ];

      # Images
      "image/png" = [ "org.gnome.Loupe.desktop" ];
      "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
      "image/gif" = [ "org.gnome.Loupe.desktop" ];
      "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
      "image/webp" = [ "org.gnome.Loupe.desktop" ];
      "image/tiff" = [ "org.gnome.Loupe.desktop" ];
      "image/bmp" = [ "org.gnome.Loupe.desktop" ];
      "image/x-icns" = [ "org.gnome.Loupe.desktop" ];

      # Documents
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "application/postscript" = [ "org.gnome.Evince.desktop" ];
      "application/x-dvi" = [ "org.gnome.Evince.desktop" ];
      "application/x-cbr" = [ "org.gnome.Evince.desktop" ];
      "application/x-cbz" = [ "org.gnome.Evince.desktop" ];
      "application/x-xzpdf" = [ "org.gnome.Evince.desktop" ];
      "image/vnd.djvu" = [ "org.gnome.Evince.desktop" ];

      # Web
      "text/html" = [ "helium.desktop" ];
      "x-scheme-handler/http" = [ "helium.desktop" ];
      "x-scheme-handler/https" = [ "helium.desktop" ];
    };
  };
}
