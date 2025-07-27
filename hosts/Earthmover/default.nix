{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../common
    ../../common/desktop
    ../../modules/common
    ../../modules/nixos
    
    ../../common/kernel.nix
  ];

  home-manager.users.wo2w = {
    imports = [
      ../../modules/home
    ];

    home.file.".config/Yubico/u2f_keys".text = "wo2w:z53Q2IqyzYjUP22RRDsf+vfD9x+AJ1ymrOFslox0IeqHCHC5JecjjtQFGYwUPkP7KG7sEQ52ZG4ZhXxSg8/UZw==,8CnIjGYN5vD+jDyk4I4HQzUDJ5eMjcZ+s2209O76u/gynbPKAXX+U7/vrWHNqKz6YqHCpvD9KpJlLbzNh/xJJg==,es256,+presence";

    home.stateVersion = "25.05";
  };

  system.stateVersion = "25.05";
}