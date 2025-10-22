{ config, lib, ... }:

{
  home-manager.users.wo2w.programs.hyprlock = {
    enable = true;
    settings = 
    let
      toHyprClr = color: "rgb(${lib.removePrefix "#" color})";

      colors = config.custom.colors;
    in {
      general.grace = 5;

      background = {
        path = "/home/wo2w/Pictures/Wallpapers/oneshot1.png";
        blur_passes = 2;
      };

      label = [
        {
          valign = "top";
          position = "0, -400";
          font_size = 128;
          text = "$TIME";
        }
        {
          position = "0, 250";
          font_size = 64;
          text = "$DESC";
        }
      ];

      input-field = {
        position = "0, -80";
        size = "400, 100";
        outline_thickness = 8;

        outer_color = toHyprClr colors.base0D;
        inner_color = toHyprClr colors.base00;
        font_color = toHyprClr colors.base05;
        check_color = toHyprClr colors.base0E;
        fail_color = toHyprClr colors.base0C;
        capslock_color = toHyprClr colors.base08;
        numlock_color = toHyprClr colors.base08;
        bothlock_color = toHyprClr colors.base08;
      };
    };
  };
}