{ config, ... }:

{
  home-manager.users.wo2w.programs.yazi = {
    enable = true;
    enableBashIntegration = true;
  };
}