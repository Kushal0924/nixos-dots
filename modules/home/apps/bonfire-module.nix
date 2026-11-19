# Bonfire's home-manager module looks its package up with `pkgs.system`, which
# nixpkgs deprecated in favour of `stdenv.hostPlatform.system` and now warns
# about on every evaluation (upstream has not been updated yet). Call the
# module ourselves with a package set where `system` is defined directly, so
# the deprecated alias is never forced.
{ pkgs, inputs, ... }@args:
inputs.bonfire.homeManagerModules.default (
  args
  // {
    pkgs = pkgs // {
      system = pkgs.stdenv.hostPlatform.system;
    };
  }
)
