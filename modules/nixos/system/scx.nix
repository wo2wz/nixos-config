{ config, pkgs, ... }:

{
  services.scx = {
    enable = true;
    package = pkgs.scx.rustscheds;
    # use gaming performance scheduler
    scheduler = "scx_lavd";
  };
}