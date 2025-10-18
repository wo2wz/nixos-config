{ config, pkgs, ... }:

{
  fonts = {
    packages = [ pkgs.nerd-fonts.hack ];

    fontconfig.defaultFonts.monospace = [ "Hack Nerd Font" ];
  };
}