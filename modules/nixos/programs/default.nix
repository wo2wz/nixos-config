{ config, ... }:

{
  imports = [
    ./bash.nix
    ./gaming.nix
    ./git.nix
  ];
}