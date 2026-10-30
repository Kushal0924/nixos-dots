# System services and hardware: networking, Bluetooth and firmware, power
# management, and the polkit authentication agent the session needs.
{
  pkgs,
  ...
}:

{
  networking.networkmanager.enable = true;

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
  };

  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;

    # The power button is handled by the session shell's menu instead of logind.
    logind.settings.Login.HandlePowerKey = "ignore";
  };

  security.polkit.enable = true;

  # Polkit needs a graphical agent, and the session shell does not provide one.
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "GNOME Polkit Authentication Agent";

    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
