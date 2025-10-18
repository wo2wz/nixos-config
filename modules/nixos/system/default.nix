{ config, ... }:

{
  imports = [
    ./desktop.nix
    ./fonts.nix
    ./home-manager.nix
    ./scx.nix
    ./swap.nix
    ./yubikey.nix
  ];
}