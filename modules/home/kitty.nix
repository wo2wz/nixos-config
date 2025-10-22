{ config, osConfig, ... }:

{
  programs.kitty = {
    enable = true;
    settings = 
    let
      colors = osConfig.custom.colors;
    in {
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      confirm_os_window_close = -1;

      font_size = 10;

      # The basic colors
      background = colors.base00;
      foreground = colors.base05;
      selection_background = colors.base03;
      selection_foreground = colors.base05;

      # Cursor colors
      cursor = colors.base05;
      cursor_text_color = colors.base00;

      # URL underline color when hovering with mouse
      url_color = colors.base04;

      # Kitty window border colors
      active_border_color = colors.base03;
      inactive_border_color = colors.base01;

      # OS Window titlebar colors
      wayland_titlebar_color = colors.base00;

      # Tab bar colors
      active_tab_background = colors.base00;
      active_tab_foreground = colors.base05;
      inactive_tab_background = colors.base01;
      inactive_tab_foreground = colors.base04;
      tab_bar_background = colors.base01;

      # The 16 terminal colors
      # normal
      color0 = colors.base00;
      color1 = colors.base08;
      color2 = colors.base0B;
      color3 = colors.base0A;
      color4 = colors.base0D;
      color5 = colors.base0E;
      color6 = colors.base0C;
      color7 = colors.base05;

      # bright
      color8 = colors.base02;
      color9 = colors.base08;
      color10 = colors.base0B;
      color11 = colors.base0A;
      color12 = colors.base0D;
      color13 = colors.base0E;
      color14 = colors.base0C;
      color15 = colors.base07;

      # extended base16 colors
      color16 = colors.base09;
      color17 = colors.base0F;
      color18 = colors.base01;
      color19 = colors.base02;
      color20 = colors.base04;
      color21 = colors.base06;
    };
  };
}