# YouTube and WhatsApp as isolated web apps, each with its own user data
# directory.
{
  lib,
  osConfig,
  ...
}:

lib.mkIf osConfig.dotfiles.apps.webapps.enable {
  programs.nix-webapps = {
    enable = true;
    browser = "helium"; # Default browser for all apps
    isolate = true; # Isolate all apps by default (separate user-data-dir)
    extraArgs = [
      # Applied to all apps (override per-app with extraArgs = [...])
      "--enable-features=UseOzonePlatform"
      "--ozone-platform-hint=auto"
    ];

    apps = {
      WhatsApp = {
        url = "https://web.whatsapp.com";
        comment = "Messaging and Calling";
        icon = ../../../assets/icons/whatsapp.png;
      };

      YouTube = {
        url = "https://www.youtube.com";
        comment = "YouTube Web App";
        icon = ../../../assets/icons/youtube.png;
      };

      ChatGPT = {
        url = "https://chat.openai.com";
        comment = "ChatGPT Web App";
        icon = ../../../assets/icons/chatgpt.png;
      };
    };
  };
}
