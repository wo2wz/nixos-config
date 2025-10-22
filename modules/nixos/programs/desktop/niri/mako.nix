{ config, ... }:

{
  home-manager.users.wo2w.services.mako = {
    enable = true;
    settings = 
    let
      colors = config.custom.colors;
    in {
      max-history = 10;
      default-timeout = 5000;
      anchor = "bottom-right";

      on-button-middle = "dismiss-group";

      border-size = 4;

      background-color = colors.base00;
      text-color = colors.base05;
      border-color = colors.base0E;
      progress-color = "over ${colors.base0C}";
    };
  };
}