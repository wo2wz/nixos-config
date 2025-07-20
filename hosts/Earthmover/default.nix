{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../common
    ../../common/desktop
    ../../modules/common
    ../../modules/nixos
  ];

  home-manager.users.wo2w = {
    imports = [
      ../../modules/home
    ];

    home.stateVersion = "25.05";
  };

  system.stateVersion = "25.05";
}