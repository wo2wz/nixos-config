{ inputs, config, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  services.scx = {
    enable = true;
    # use gaming performance scheduler
    scheduler = "scx_lavd";
  };
}