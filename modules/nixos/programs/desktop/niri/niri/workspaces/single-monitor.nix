{ config, ... }:

{
  home-manager.users.wo2w.programs.niri.settings.workspaces = {
    "01-code".name = "code";
    "02-fullscreen".name = "fullscreen";
    "03-gaming".name = "gaming";
  };
}