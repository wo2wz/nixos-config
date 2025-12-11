{ config, ... }:

{
  imports = [
    ./minecraft-server.nix
    ./restic.nix
    ./sops.nix
    ./velocity.nix
  ];
}