{
  lib,
  pkgs,
  osConfig,
  helix-steel,
  helixPlugins,
  ...
}:

let
  biomeFmt = ext: {
    command = lib.getExe pkgs.biome;
    args = [
      "format"
      "--stdin-file-path"
      "stdin.${ext}"
    ];
  };
in
lib.mkIf osConfig.dotfiles.apps.helix.enable {
  programs.nhx = {
    enable = true;

    steel = {
      enable = true;
      lsp.enable = true; # Steel LSP for editing .scm files
    };

    settings = {
      theme = "noctalia";
      editor.lsp.display-messages = true;
      editor.indent-guides = {
        render = true;
        character = "│";
      };
    };

    plugins.forest = {
      enable = true;
      config = {
        style = "snacks"; # persistent sidebar
        position = "left";
        ignore = [
          ".git"
          "target"
          "node_modules"
        ];
      };
    };

    # languages: see the note below
    languages = {
      language-server = {
        nil = {
          command = lib.getExe pkgs.nil;
          config.nil.formatting.command = [ (lib.getExe pkgs.nixfmt) ];
          config.nil.nix.flake.autoArchive = true;
        };
        taplo = {
          command = lib.getExe pkgs.taplo;
          args = [
            "lsp"
            "stdio"
          ];
        };
        typescript-language-server.command = lib.getExe pkgs.typescript-language-server;
        biome = {
          command = lib.getExe pkgs.biome;
          args = [ "lsp-proxy" ];
        };
        vscode-html-language-server = {
          command = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";
          args = [ "--stdio" ];
        };
        vscode-css-language-server = {
          command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
          args = [ "--stdio" ];
        };
      };

      language = [
        {
          name = "nix";
          auto-format = true;
          language-servers = [ "nil" ];
          formatter.command = lib.getExe pkgs.nixfmt;
        }
        {
          name = "toml";
          auto-format = true;
          language-servers = [ "taplo" ];
          formatter = {
            command = lib.getExe pkgs.taplo;
            args = [
              "format"
              "-"
            ];
          };
        }
        {
          name = "javascript";
          auto-format = true;
          language-servers = [
            "typescript-language-server"
            "biome"
          ];
          formatter = biomeFmt "js";
        }
        {
          name = "typescript";
          auto-format = true;
          language-servers = [
            "typescript-language-server"
            "biome"
          ];
          formatter = biomeFmt "ts";
        }
        {
          name = "css";
          auto-format = true;
          language-servers = [
            "vscode-css-language-server"
            "biome"
          ];
          formatter = biomeFmt "css";
        }
        {
          name = "html";
          auto-format = true;
          language-servers = [ "vscode-html-language-server" ];
          formatter = {
            command = lib.getExe pkgs.prettier;
            args = [
              "--parser"
              "html"
            ];
          };
        }
      ];
    };
  };
}
