{ config, ... }:

{
  imports = [
    ./btop.nix
    ./bash.nix
    ./git.nix
    ./kitty.nix
    ./librewolf.nix
    ./plasma.nix
    ./spicetify.nix
    ./vesktop.nix
    ./vscodium.nix
  ];
}