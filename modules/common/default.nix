{ config, ... }:

{
  imports = [
    ./boot.nix
    ./default-packages.nix
    ./locales.nix
    ./nix.nix
    ./users.nix
  ];
}