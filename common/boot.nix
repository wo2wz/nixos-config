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
    package = pkgs.scx.rustscheds;
    # use gaming performance scheduler
    scheduler = "scx_lavd";
  };
}