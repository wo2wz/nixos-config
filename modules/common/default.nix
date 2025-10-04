{ config, pkgs, lib, ... }:

{
  imports = [
    ./boot.nix
    ./default-packages.nix
    ./locales.nix
    ./networking.nix
    ./nix.nix
    ./users.nix
  ];
}