{ config, ... }:

{
  imports = [
    ./bash.nix
    ./desktop-files.nix
    ./git.nix
    ./kitty.nix
    ./librewolf.nix
    ./plasma.nix
    ./spicetify.nix
    ./vesktop.nix
    ./vscodium.nix
  ];
}