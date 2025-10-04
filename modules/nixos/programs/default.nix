{ config, ... }:

{
  imports = [
    ./bash.nix
    ./gaming.nix
    ./git.nix
    ./kde.nix
    ./ssh.nix
  ];
}