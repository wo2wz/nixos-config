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

  # config for ZFS external storage
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "58bae81c";
  fileSystems = {
    "/mnt/external" = {
      device = "zpool-mirror";
      fsType = "zfs";
    };
    
    "/mnt/external/backup" = {
      device = "zpool-mirror/backup";
      fsType = "zfs";
    };

    "/mnt/external/storage" = {
      device = "zpool-mirror/storage";
      fsType = "zfs";
    };

    # bind mounts for file storage dirs from external storage
    "/var/lib/nextcloud/data/2fc6e1af776402040d95e1d5adc3babe4928587e84170c882815c808b472b3fa" = {
      depends = [ "/mnt/external/storage" ];
      device = "/mnt/external/storage/nextcloud/data/2fc6e1af776402040d95e1d5adc3babe4928587e84170c882815c808b472b3fa";
      fsType = "none";
      options = [ "bind" ];
    };
  };

  services.zfs.autoScrub.enable = true;

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

