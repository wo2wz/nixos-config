{ hostName, config, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    
    ../../common/boot.nix
    ../../common/locales.nix
    ../../common/nix.nix
    ../../common/users.nix

    ../../modules/nixos/bash.nix
  ];
  
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/swap".options = [ "noatime" ];
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 8192;
  }];

  networking.hostName = "${hostName}";

  environment.defaultPackages = lib.mkForce [];
  
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "wo2wz";
        email = "189177184+wo2wz@users.noreply.github.com";
      };
      safe.directory = "/etc/nixos";
    };
  };

  services.scx.scheduler = lib.mkForce "scx_rusty";

  system.stateVersion = "25.05";
}
