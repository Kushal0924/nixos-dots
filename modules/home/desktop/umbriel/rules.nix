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
      # Blur behind every window — niri's global background-effect. Windows
      # stay opaque (no opacity rule), so the blur only shows through where an
      # application draws transparency itself.
      {
        blur = true;
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

      # The bar sits on the wallpaper and is not blurred at all (niri's
      # `blur false`); later rules override earlier ones.
      {
        match.namespace = "^noctalia-bar";
        blur = false;
      }
    ];
  };
}
