{ config, pkgs, lib, ... }:

{
  home-manager.users.wo2w.programs.fuzzel = {
    enable = true;
    settings =
    let
      toRgba = color: "${lib.removePrefix "#" color}ff";

      colors = config.custom.colors;
    in {
      main.placeholder = "type something already...";

      border.width = 5;
      colors = {
        background = toRgba colors.base00;
        text = toRgba colors.base05;
        prompt = toRgba colors.base05;
        placeholder = toRgba colors.base03; 
        input = toRgba colors.base05;
        match = toRgba colors.base0C;
        selection = toRgba colors.base03;
        selection-text = toRgba colors.base05;
        selection-match = toRgba colors.base0C;
        counter = toRgba colors.base03;
        border = toRgba colors.base0D;
      };
    };
  };
}