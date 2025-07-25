{ config, pkgs, ... }:

{
  services = {
    displayManager.sddm = {
      enable = true;
      wayland = {
        enable = true;
        compositor = "kwin";
      };
    };
    desktopManager.plasma6.enable = true;
  };
  
  programs.kdeconnect.enable = true;

  # remove unnecessary packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    discover
    konsole
    khelpcenter
    krdp
  ];
}