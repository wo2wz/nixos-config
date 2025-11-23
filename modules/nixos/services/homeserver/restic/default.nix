{ config, ... }:

{
  imports = [
    ./backups.nix
    ./rest-server.nix
  ];
}