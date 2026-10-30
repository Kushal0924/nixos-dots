{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.dotfiles.apps.nautilus.enable {
  home.packages = with pkgs; [
    nautilus-python
  ];

  xdg.configFile."nautilus/scripts/open-in-kitty" = {
    text = ''
      #!/usr/bin/env bash
      if [ -n "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ]; then
        set -- $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
        dir="$1"
      elif [ -n "$NAUTILUS_SCRIPT_CURRENT_URI" ]; then
        dir=$(echo "$NAUTILUS_SCRIPT_CURRENT_URI" | sed 's|file://||; s|%20| |g')
      else
        dir=$PWD
      fi
      kitty --directory "$dir" &
    '';
    executable = true;
  };
}
