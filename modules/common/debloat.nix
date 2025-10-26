{ config, lib, ... }:

{
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/profiles/minimal.nix
  
  documentation = {
    doc.enable = false;
    info.enable = false;
  };

  environment = {
    defaultPackages = lib.mkForce [];
    stub-ld.enable = false;
  };

  programs.command-not-found.enable = false;

  boot.enableContainers = false;

  services.logrotate.enable = false;
}