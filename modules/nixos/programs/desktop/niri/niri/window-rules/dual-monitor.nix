{ config, ... }:

{
  home-manager.users.wo2w.programs.niri.settings.window-rules = [
    {
      matches = [{ app-id = "vesktop"; }];
      open-on-workspace = "vesktop";
    }
  ];
}