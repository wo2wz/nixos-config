{ config, ... }:

{
  imports = [
    ./btop.nix
    ./bash.nix
    ./git.nix
    ./kitty.nix
    ./librewolf.nix
    ./vesktop.nix
    ./vscodium.nix
  ];
}