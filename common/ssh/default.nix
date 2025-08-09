{ config, ... }:

{
  imports = [
    ./client.nix
    ./server.nix
  ];
}