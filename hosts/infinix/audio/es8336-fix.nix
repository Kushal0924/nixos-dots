# Out-of-tree snd-soc-sof_es8336 machine driver with the headphone GPIO
# inversion removed. See ./patch/README.md for details.
{
  stdenv,
  lib,
  kernel,
}:

stdenv.mkDerivation {
  pname = "es8336-fix";
  version = "1.0";

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
