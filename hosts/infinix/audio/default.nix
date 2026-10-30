# Audio for this particular machine: an Intel SOF (Sunny/Elkhart Lake) codec
# paired with an ES8336 amplifier.
{
  config,
  pkgs,
  ...
}:

{
  boot = {
    # The in-tree ES8336 machine driver has a headphone GPIO inversion bug on
    # recent kernels, so build a patched module out of tree.
    extraModulePackages = [
      (config.boot.kernelPackages.callPackage ./es8336-fix.nix { })
    ];

    extraModprobeConfig = ''
      options snd-soc-sof_es8336 quirk=128
    '';

    kernelModules = [ "snd-soc-sof_es8336" ];
  };

  environment.systemPackages = with pkgs; [
    alsa-ucm-conf
    alsa-utils
    sof-firmware
  ];

  # The headphone capture control comes up muted after boot, so unmute it once
  # the sound stack has settled.
  systemd.services.audio-unmute = {
    description = "Audio Unmute Fix";
    wantedBy = [ "multi-user.target" ];
    after = [ "sound.target" ];

    # Ensure alsa-utils is available for amixer
    path = [ pkgs.alsa-utils ];

    script = ''
      sleep 30
      amixer -c "0" sset 'Headphone' cap unmute
    '';
  };
}
