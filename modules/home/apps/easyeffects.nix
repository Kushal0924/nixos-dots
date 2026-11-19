# EasyEffects audio effects daemon, wired into PipeWire by its Home Manager
# module. Needs programs.dconf.enable, which dotfiles.desktop provides.
{
  lib,
  osConfig,
  ...
}:

lib.mkIf osConfig.dotfiles.apps.easyeffects.enable {
  services.easyeffects.enable = true;
}
