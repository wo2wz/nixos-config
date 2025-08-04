{ config, pkgs, ... }:

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

    programs.btop = {
      package = pkgs.btop-rocm;
      settings = {
        shown_boxes = "cpu mem net proc gpu0";
        custom_cpu_name = "Core i5-12400F";
        custom_gpu_name0 = "RX 6700 XT";
      };
    };

    home.file.".config/Yubico/u2f_keys".text = "wo2w:z53Q2IqyzYjUP22RRDsf+vfD9x+AJ1ymrOFslox0IeqHCHC5JecjjtQFGYwUPkP7KG7sEQ52ZG4ZhXxSg8/UZw==,8CnIjGYN5vD+jDyk4I4HQzUDJ5eMjcZ+s2209O76u/gynbPKAXX+U7/vrWHNqKz6YqHCpvD9KpJlLbzNh/xJJg==,es256,+presence";

    home.stateVersion = "25.05";
  };

  system.stateVersion = "25.05";
}