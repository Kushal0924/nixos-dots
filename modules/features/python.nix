{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.dotfiles.features.python.enable {
  environment.systemPackages = [
    (pkgs.python3.withPackages (
      ps: with ps; [
        numpy
        onnxruntime
        pillow
        pip
        setuptools
        tkinter
        wheel
      ]
    ))

    pkgs.uv
  ];
}
