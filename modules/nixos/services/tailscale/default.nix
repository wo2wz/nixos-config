{ config, ... }:

{
  imports = [
    ./main.nix
    ./ssh.nix
  ];
}