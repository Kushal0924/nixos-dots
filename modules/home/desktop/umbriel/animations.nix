# Animation timings in umbriel's curves: springs as
# `spring:<damping>,<stiffness>`, easing curves as named Béziers. Set
# `enabled = false` in the `animation` table to stop everything.
{
  lib,
  osConfig,
  ...
}:

lib.mkIf osConfig.dotfiles.desktop.enable {
  programs.umbriel.settings.animation = {
    beziers = {
      ease_out_expo = [
        0.16
        1.0
        0.3
        1.0
      ];
      ease_out_quad = [
        0.25
        0.46
        0.45
        0.94
      ];
    };

    # niri's window-open: 150 ms ease-out-expo.
    windows_in = {
      enabled = true;
      duration_ms = 150;
      curve = "ease_out_expo";
    };

    # niri's window-close: 150 ms ease-out-quad.
    windows_out = {
      enabled = true;
      duration_ms = 150;
      curve = "ease_out_quad";
    };

    # niri's window-movement: damping 1.0, stiffness 800. niri also animated
    # resizes with the same spring, but `animation.windows_resize` does not
    # exist in the packaged umbriel yet, so size changes snap while the move
    # still animates.
    windows_move.curve = "spring:1,800";

    # niri's workspace-switch: damping 1.0, stiffness 1000.
    workspaces.curve = "spring:1,1000";

    # niri's overview-open-close, with the workspace filmstrip on the switch
    # curve.
    overview = {
      curve = "spring:1,800";
      workspace_curve = "spring:1,1000";
    };

    # niri has no focus-border colour animation, and does not dim unfocused
    # windows.
    border.enabled = false;
    dim_unfocused.enabled = false;
  };
}
