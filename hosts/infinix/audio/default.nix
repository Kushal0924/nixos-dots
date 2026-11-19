# Audio for this particular machine: an Intel SOF (Sunny/Elkhart Lake) codec
# paired with an ES8326 amplifier.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  # UCM2 profiles that actually know about the ES8326. Without them the
  # internal microphone never shows up in PipeWire. See ./ucm.nix.
  alsaUcm = pkgs.callPackage ./ucm.nix { inherit (pkgs) alsa-ucm-conf; };

  # alsa-lib resolves UCM2 profiles through ALSA_CONFIG_UCM2 when it is set.
  # PipeWire and WirePlumber are the processes that open the card, so they
  # need to see the patched profile tree.
  ucmEnvironment = lib.mkIf config.services.pipewire.enable {
    ALSA_CONFIG_UCM2 = "${alsaUcm}/share/alsa/ucm2";
  };
in
{
  boot = {
    # The in-tree ES8336 machine driver drives the headphone GPIO inverted
    # on recent kernels. Build the patched module out of tree; it selects
    # the non-inverted quirk from DMI, so no modprobe override is needed
    # (and a leftover quirk= would turn the inversion back on and break the
    # speaker). Leave its hdmi_num parameter alone: the shipped tplg has
    # three HDMI backend links.
    extraModulePackages = [
      (config.boot.kernelPackages.callPackage ./es8336-fix.nix { })
    ];

    kernelModules = [ "snd-soc-sof_es8336" ];
  };

  systemd.user.services = {
    pipewire.environment = ucmEnvironment;
    pipewire-pulse.environment = ucmEnvironment;
    wireplumber.environment = ucmEnvironment;
  };

  environment = {
    systemPackages = with pkgs; [
      alsa-ucm-conf
      alsa-utils
      sof-firmware
    ];

    # Keep `alsaucm` in an interactive shell consistent with the sound stack
    # so the profile can be inspected without exporting the variable by hand.
    sessionVariables = lib.mkIf config.services.pipewire.enable {
      ALSA_CONFIG_UCM2 = "${alsaUcm}/share/alsa/ucm2";
    };
  };
}
