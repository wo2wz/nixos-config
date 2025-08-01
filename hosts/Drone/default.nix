{ config, lib, ... }:

{
  imports = [
    ../../common/boot.nix
    ../../common/locales.nix
    ../../common/nix.nix
    ../../common/users.nix

    ../../modules/nixos/bash.nix
  ];

  networking.hostName = "${hostName}";

  environment.defaultPackages = lib.mkForce [];

  services.scx.scheduler = lib.mkForce "scx_rusty";
}