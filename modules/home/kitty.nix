{ config, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      confirm_os_window_close = -1;
    };
  };
}