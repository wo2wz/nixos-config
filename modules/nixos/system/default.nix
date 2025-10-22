{ config, ... }:

{
  imports = [
    ./colors.nix
    ./console-colors.nix
    ./desktop.nix
    ./fonts.nix
    ./home-manager.nix
    ./laptop.nix
    ./scx.nix
    ./swap.nix
    ./yubikey.nix
    ./zswap.nix
  ];
}