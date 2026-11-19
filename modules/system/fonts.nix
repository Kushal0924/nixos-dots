{
  pkgs,
  ...
}:

let
  # Pirata One is not packaged in nixpkgs on its own. Fetch the single TTF
  # (and its license) from a pinned google/fonts revision rather than pulling
  # the whole multi-gigabyte google-fonts source tree.
  pirata-one =
    pkgs.runCommand "pirata-one-font"
      {
        src = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/google/fonts/222f19bc2c50503f3c9a62faa19b69349fa54a8e/ofl/pirataone/PirataOne-Regular.ttf";
          hash = "sha256-U0ei4VVYns9mfUt2ZhPI7gA+3en4Nxf9JMCVmaSx7MA=";
        };
        license = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/google/fonts/222f19bc2c50503f3c9a62faa19b69349fa54a8e/ofl/pirataone/OFL.txt";
          hash = "sha256-6K0/PeW67/a6xucR2MQG4Ka4ph0pRHQVMtiWXYk6JoE=";
        };
      }
      ''
        install -Dm444 $src $out/share/fonts/truetype/PirataOne-Regular.ttf
        install -Dm444 $license $out/share/doc/pirata-one/OFL.txt
      '';
in
{
  fonts.packages = with pkgs; [
    annotation-mono
    pirata-one
    nerd-fonts.departure-mono
    nerd-fonts.jetbrains-mono
    noto-fonts-color-emoji
  ];
}
