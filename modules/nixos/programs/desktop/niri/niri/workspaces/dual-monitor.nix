{ config, ... }:

{
  home-manager.users.wo2w.programs.niri.settings.workspaces = {
    "01-DP-1-code" = {
      name = "code";
      open-on-output = "DP-1";
    };
    "02-DP-1-vesktop" = {
      name = "vesktop";
      open-on-output = "DP-1";
    };
    "03-DP-1-gaming" = {
      name = "gaming";
      open-on-output = "DP-1";
    };
    "04-DP-2-fullscreen" = {
      name = "fullscreen";
      open-on-output = "DP-2";
    };
  };
}