{ config, pkgs, lib, ... }:

{
  imports = [
    ./ssh
    
    ./boot.nix
    ./home-manager.nix
    ./locales.nix
    ./networking.nix
    ./nix.nix
    ./swap.nix
    ./users.nix
  ];

  environment = {
    systemPackages = with pkgs; [ wget ];

    # remove default packages
    defaultPackages = lib.mkForce [ ];
  };
}