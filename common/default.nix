{ config, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./home-manager.nix
    ./locales.nix
    ./networking.nix
    ./nix.nix
    ./swap.nix
    ./users.nix
  ];
}