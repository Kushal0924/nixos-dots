{
  pkgs,
  ...
}:

{
  # Libraries for building/launching foreign binaries that expect a normal
  # dynamic linker (VS Code extensions, AppImages, ...).
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      fontconfig
      freetype
      glibc
      glib
      libGL
      libxkbcommon
      libxml2
      openssl
      stdenv.cc.cc
      stdenv.cc.cc.lib
      util-linux
      wayland
      xdg-utils
      zlib
    ];
  };
}
