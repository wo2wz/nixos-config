{ config, ... }:

{
  imports = [
    ./boot.nix
    ./debloat.nix
    ./locales.nix
    ./nix.nix
    ./users.nix
  ];
}