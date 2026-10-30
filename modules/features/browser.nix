# Helium is the system-wide browser (it is also what nix-webapps launches).
{
  config,
  inputs,
  lib,
  pkgs,
  userName,
  ...
}:

let
  user = if config.dotfiles ? userName then config.dotfiles.userName else userName;
in
lib.mkIf config.dotfiles.features.browser.enable {
  environment.systemPackages = [
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Noctalia chromium-based template: prepare managed policy for Helium/Chromium
  # Use 'f' (not 'f+') so Noctalia can write the rendered color and it persists across rebuilds.
  systemd.tmpfiles.rules = [
    "d /etc/chromium/policies/managed 0755 root root - -"
    "f /etc/chromium/policies/managed/noctalia-color.json 0644 ${user} users - {}"
  ];
}
