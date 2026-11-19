# Out-of-tree snd-soc-sof_es8336 machine driver with the headphone GPIO
# inversion removed, DMI quirks for the Infinix laptops and an optional HDMI
# FE PCM count override. Vendored from the es8326-fix-with-2hdmi branch of
# https://github.com/hmtheboy154/dotfiles-infinix-es8326
# Discussion: https://github.com/Abhinav5383/infinix-x2-audio-fix/issues/2
{
  stdenv,
  lib,
  kernel,
}:

stdenv.mkDerivation {
  pname = "es8336-fix";
  version = "2.0";

  src = ./patch;

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildPhase = ''
    runHook preBuild

    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      M=$PWD \
      modules

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/extra"

    install -m644 \
      snd-soc-sof_es8336.ko \
      "$out/lib/modules/${kernel.modDirVersion}/extra/"

    runHook postInstall
  '';

  dontStrip = true;

  meta = {
    description = "ASoC Intel SOF + ES8336 Machine driver fix";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
