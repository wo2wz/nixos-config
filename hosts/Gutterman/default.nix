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

  networking = {
    useDHCP = false;
    interfaces.enp0s20f0u1.ipv4.addresses = [{
      # ip leak
      address = "192.168.2.129";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.2.1";
    nameservers = [
      "192.168.2.19"
      "1.1.1.1"
    ];
  };

  environment.systemPackages = [
    pkgs.btop
    pkgs.steamcmd
  ];

  system.stateVersion = "25.11";
}
