{
  pkgs,
  ...
}:

{
  # GTK/libadwaita apps are everywhere in the session, so theme and schema
  # packages are system-wide rather than per-user.
  environment.systemPackages = with pkgs; [
    adw-gtk3
    adwaita-icon-theme
    bibata-cursors
    gsettings-desktop-schemas
    glib
    material-design-icons
    nwg-look
  ];
}
