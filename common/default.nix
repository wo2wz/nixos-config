{ config, pkgs, lib, ... }:

{
  imports = [
    ./boot.nix
    ./home-manager.nix
    ./locales.nix
    ./networking.nix
    ./nix.nix
    ./swap.nix
    ./users.nix
  ];

  environment = {
    systemPackages = with pkgs; [ wget ];

    # remove perl from default packages
    defaultPackages = with pkgs; lib.mkForce [ rsync strace ];
  };
}