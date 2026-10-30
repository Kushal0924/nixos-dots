# The graphical session: compositor, login screen, and the audio/portal stack
# every session needs. The greeter module is imported unconditionally from
# ./default.nix; whether the greeter actually runs is decided by
# `services.displayManager.noctalia-greeter.enable` here.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.dotfiles.desktop.enable {
  # The only session offered at the greeter. Take umbriel from the flake input
  # rather than nixpkgs: nixpkgs still packages the 2026-10-16 snapshot, which
  # predates server-side title bars, while Noctalia 5.4 writes
  # [colors.title_bar] and umbriel rejects the whole config as invalid. The
  # portal stays on nixpkgs' cached build.
  programs.umbriel = {
    enable = true;
    package = inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default;
    portalPackage = pkgs.xdg-desktop-portal-umbriel;
  };

  services = {
    displayManager.sessionPackages = lib.mkForce [ config.programs.umbriel.package ];

    displayManager.noctalia-greeter = {
      enable = true;

      greeter-args = "";
      settings = {
        cursor = {
          theme = "Bibata-Modern-Ice";
          size = 24;
          path = "${pkgs.bibata-cursors}/share/icons";
        };
        keyboard = {
          layout = "us";
        };
      };
    };

    libinput.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;

      # PipeWire's x11-bell module holds an X11 connection to Xwayland's :0 so
      # it can ring the system bell for X11 clients. Umbriel restarts Xwayland
      # now and then, and when that display dies the module's X11 I/O error
      # handler runs loop_destroy_source() on an already destroyed source and
      # takes the whole daemon down with it (SIGSEGV in libspa-support.so; ~20
      # core dumps in three days, every one of them right after "[wlr]
      # Restarting Xwayland").
      #
      # systemd restarts PipeWire, WirePlumber then rebuilds every sink from
      # its saved defaults, and that is the random reset: speaker volume snaps
      # back and the headphone pin switch comes back muted, so alsamixer shows
      # MM instead of OO. Ringing bells for the odd X11 app is not worth that,
      # so disable the module. The entry is gated by
      # `condition = [ { module.x11.bell = !false } ]`, so setting the property
      # to false skips it; verified locally that the module is then skipped and
      # never opens an X connection. PipeWire's keys are dotted, so they must
      # be quoted here: an unquoted `context.properties` would nest two objects
      # instead of producing the single `context.properties` section key.
      extraConfig.pipewire."90-no-x11-bell" = {
        "context.properties" = {
          "module.x11.bell" = false;
        };
      };
    };
  };

  programs.dconf.enable = true;

  # Umbriel starts the real Xwayland for X11 applications.
  environment.systemPackages = [
    pkgs.xwayland
  ];
}
