# Flatpak with the Flathub remote preconfigured, for apps that are not packaged
# in nixpkgs.
{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.dotfiles.features.flatpak.enable {
  services.flatpak.enable = true;

  # services.flatpak only sets up the runtime; remotes are added explicitly.
  # The remote is checked up front because `flatpak remote-add
  # --if-not-exists` still downloads the .flatpakrepo file even when the
  # remote is already configured. That makes the unit require working DNS,
  # and it fails during activation while NetworkManager restarts. Once the
  # remote exists the network is not needed at all, and restartIfChanged
  # keeps the unit from being rerun on every `nixos-rebuild switch`.
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    restartIfChanged = false;
    path = [
      pkgs.flatpak
      pkgs.gnugrep
    ];
    script = ''
      if ! flatpak remotes --system --columns=name | grep -qx flathub; then
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      fi
    '';
  };
}
