{ inputs, config, pkgs, ... }:

{
  home-manager.users.wo2w.services.flameshot = {
    enable = true;
    # FIXME use unstable version for 13.0.0 update
    package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.flameshot;

    settings.General = {
      useGrimAdapter = true;
      disabledGrimWarning = true;

      savePath = "/home/wo2w/Pictures/Screenshots";
      savePathFixed = true;

      startupLaunch = false;
      showStartupLaunchMessage = false;
      autoCloseIdleDaemon = true;
      disabledTrayIcon = true;
    };
  };
}