{ config, pkgs, ... }:

{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = [
      pkgs.cups-filters
      pkgs.cups-browsed

      pkgs.epson-escpr
      pkgs.cups-brother-hll2375dw
    ];
  }; 
}