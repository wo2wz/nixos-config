{ config, ... }:

{
  home-manager.users.wo2w.services.mako = {
    enable = true;
    settings = 
    let
      colors = config.custom.colors;
    in {
      anchor = "bottom-right";
      outer-margin = "0,5,20,0"; 

      border-size = 4;

      on-button-middle = "dismiss-group";

      max-history = 10;
      default-timeout = 5000;

      background-color = colors.base00;
      text-color = colors.base05;
      border-color = colors.base0E;
      progress-color = "over ${colors.base0C}";
    };
  };
}