{ hostName, config, lib, ... }:

{
  imports = [
    ../../common/boot.nix
    ../../common/locales.nix
    ../../common/nix.nix
    ../../common/users.nix

    ../../modules/nixos/bash.nix
  ];

  swapDevices = [{ 
    device = "/swap/swapfile"; 
    size = 8*1024;
  }];

  networking.hostName = "${hostName}";

  environment.defaultPackages = lib.mkForce [];

  services.scx.scheduler = lib.mkForce "scx_rusty";

  system.stateVersion = "25.05";
}