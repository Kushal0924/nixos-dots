# Jupyter plus the analysis stack that notebooks actually import.
#
# This is a second `python3.withPackages` environment rather than an extension
# of `python.nix`: the scientific packages are a large build, and a host that
# only scripts (or trains a model) should never pay for them.
{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.dotfiles.features.jupyter.enable {
  environment.systemPackages = [
    (pkgs.python3.withPackages (
      ps: with ps; [
        # `jupyter` is the CLI entry point; the `ipykernel` entry installs a
        # kernelspec into this environment, so the kernel a notebook runs under
        # imports the same pandas/matplotlib/statsmodels as the server does.
        jupyter
        ipykernel

        # Wrapping plots in this environment need a backend that renders
        # without a display; the default agg one is chosen in the notebook.
        matplotlib

        pandas
        scikit-learn
        scipy
        seaborn
        statsmodels
      ]
    ))
  ];
}
