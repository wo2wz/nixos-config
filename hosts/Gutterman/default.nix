{ inputs, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/common

    ../../modules/nixos/programs/bash.nix
    ../../modules/nixos/programs/git.nix

    ../../modules/nixos/services/tailscale
    ../../modules/nixos/services/tailscale/exit-node/server.nix
    ../../modules/nixos/services/gameserver
    ../../modules/nixos/services/restic.nix
    ../../modules/nixos/services/sops.nix

    ../../modules/nixos/system/laptop/auto-cpufreq.nix
    ../../modules/nixos/system/minimal.nix
  ];

  environment.systemPackages = [
    pkgs.btop
    pkgs.steamcmd
  ];

  system.stateVersion = "25.11";
}
