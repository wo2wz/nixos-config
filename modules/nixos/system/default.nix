{ config, ... }:

{
  imports = [
    ./desktop.nix
    ./home-manager.nix
    ./scx.nix
    ./stylix.nix
    ./swap.nix
    ./yubikey.nix
  ];
}