{ config, ... }:

{
  imports = [
    ./gaming.nix
    ./kde.nix
    # ./niri.nix
    ./ssh.nix
  ];
}