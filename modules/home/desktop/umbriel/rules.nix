# Window and layer rules: rounding lives in `settings.nix` (umbriel has no
# per-rule equivalent needed for it), this file carries blur and Noctalia's
# own surfaces.
{
  lib,
  osConfig,
  ...
}:

lib.mkIf osConfig.dotfiles.desktop.enable {
  programs.umbriel.settings = {
    window_rule = [
      # Backdrop blur behind every window. The opacity makes windows slightly
      # translucent so the blur is actually visible; without it an opaque app
      # covers the blurred backdrop completely. `blur_optimized = false` blurs
      # the live content behind each window instead of the cached wallpaper.
      {
        blur = true;
        opacity = 0.85;
        blur_optimized = false;
      }

      # Floating Noctalia settings window.
      {
        match.app_id = "^dev.noctalia.Noctalia$";
        default_floating = true;
        default_floating_size_px = {
          width = 600;
          height = 400;
        };
      }
    ];

    layer_rule = [
      # Noctalia's panels blur the live content behind them: `blur_optimized =
      # false` is the umbriel form of niri's `xray false`, and
      # `blur_ignore_alpha` keeps fully transparent pixels unblurred.
      {
        match.namespace = ''^noctalia-(bar-[^"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^"]*)$'';
        blur = true;
        blur_ignore_alpha = 0.5;
        blur_popups = true;
        blur_optimized = false;
      }

      # The bar sits on the wallpaper, so it can use the cheaper cached
      # wallpaper blur instead of sampling live content behind it.
      {
        match.namespace = "^noctalia-bar";
        blur = true;
        blur_optimized = true;
      }
    ];
  };
}
