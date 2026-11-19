# ALSA UCM2 profiles with real ES8326 support for the Intel sof-essx8336
# machine driver.
#
# The stock sof-essx8336 profile is written for the ES8316/ES8336 codecs and
# drives controls the ES8326 does not have ("Differential Mux", "Digital Mic
# Mux"). alsa-lib aborts an entire EnableSequence when a cset fails, so the
# internal microphone section is never initialised and the card only ever
# exposes an "unplugged" headset microphone.
#
# This overlays the ES8326 branch of android-generic's alsa-ucm-conf fork on
# top of the stock tree, keeping every other profile at the nixpkgs version.
# Upstream discussion: https://github.com/Abhinav5383/infinix-x2-audio-fix/issues/2
{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  alsa-ucm-conf,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "alsa-ucm-conf-es8326";
  version = "${alsa-ucm-conf.version}-es8326";

  src = fetchFromGitHub {
    owner = "android-generic";
    repo = "external_alsa-ucm-conf";
    rev = "09c4b4b2d55b48b7d94aeb06e5fa7c9d2b33d321";
    hash = "sha256-TxyvyjXHVBENFhiNO/bzzlrY7RkHhNcMP9PS04BLic8=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/alsa"
    cp -a ${alsa-ucm-conf}/share/alsa/ucm2 "$out/share/alsa/ucm2"
    chmod -R u+w "$out/share/alsa/ucm2"

    # Entirely new: the ES8326 codec snippets.
    mkdir -p "$out/share/alsa/ucm2/codecs/es8326"
    cp ${finalAttrs.src}/ucm2/codecs/es8326/*.conf \
      "$out/share/alsa/ucm2/codecs/es8326/"

    # The fork factors the ES8316 init/headset-mic bits out of the machine
    # profile into the shared codecs directory as well.
    install -m644 \
      ${finalAttrs.src}/ucm2/codecs/es8316/init.conf \
      ${finalAttrs.src}/ucm2/codecs/es8316/HeadsetMic.conf \
      "$out/share/alsa/ucm2/codecs/es8316/"

    # The machine profile now selects the codec at runtime instead of
    # unconditionally using ES8316 controls.
    install -m644 \
      ${finalAttrs.src}/ucm2/Intel/sof-essx8336/HiFi.conf \
      ${finalAttrs.src}/ucm2/Intel/sof-essx8336/sof-essx8336.conf \
      "$out/share/alsa/ucm2/Intel/sof-essx8336/"

    runHook postInstall
  '';

  meta = {
    description = "alsa-ucm-conf with ES8326 support for sof-essx8336";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
