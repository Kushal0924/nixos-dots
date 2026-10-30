{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.dotfiles.apps.vscode.enable {
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      yzhang.markdown-all-in-one
    ];
  };
}
