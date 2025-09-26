{ hostName, inputs, config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    
    ../../common/ssh/server.nix
    ../../common/boot.nix
    ../../common/locales.nix
    ../../common/nix.nix
    ../../common/users.nix

    ../../modules/nixos/bash.nix
    ../../modules/nixos/tailscale.nix
    ../../modules/nixos/homeserver
  ];
  
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/swap".options = [ "noatime" ];
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 8192;
  }];

  networking = {
    hostName = "${hostName}";
    firewall = lib.mkForce {
      allowedTCPPorts = [];
      allowedTCPPortRanges = [];
      allowedUDPPorts = [];
      allowedUDPPortRanges = [];
    };
  };

  environment.defaultPackages = lib.mkForce [];
  
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "wo2wz";
        email = "189177184+wo2wz@users.noreply.github.com";
      };
      safe.directory = "/etc/nixos";
    };
  };

  services = {
    scx.scheduler = lib.mkForce "scx_rusty";

    # for cloudflare browser ssh
    openssh.settings.Macs = [
        "hmac-sha2-512"
        "hmac-sha2-256"
    ];
  };

  system.stateVersion = "25.05";
}

