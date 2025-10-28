{ inputs, config, modulesPath, lib, pkgs, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")

    ../../modules/common

    ../../modules/nixos/programs/bash.nix
    ../../modules/nixos/programs/git.nix

    ../../modules/nixos/services/tailscale

    ../../modules/nixos/system/headless.nix
    ../../modules/nixos/system/minimal.nix
  ];

  proxmoxLXC = {
    manageNetwork = false;
    manageHostName = true;
    privileged = true;
  };

  boot.loader.systemd-boot.enable = lib.mkForce false;

  services.fstrim.enable = false;

  services.resolved.extraConfig = ''
    Cache=true
    CacheFromLocalhost=true
  '';

  networking.firewall = {
    allowedTCPPorts = [
      8000
      8001
    ];
    allowedUDPPorts = [
      8000
      8001
    ];
  };

  environment.systemPackages =
  let
    nixpkgs-unstable = import inputs.nixpkgs-unstable {
      system = "${pkgs.system}";
      config.allowUnfree = true;
    };
  in [
    pkgs.btop
    nixpkgs-unstable.graalvmPackages.graalvm-oracle_17
    inputs.nixpkgs-pin.legacyPackages.${pkgs.system}.graalvm-ce
    pkgs.steamcmd
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}