{ inputs, config, pkgs, lib, ... }:

{
  users.groups.velocity-secret.members = [
    "velocity"
    "minecraft"
  ];
  sops.secrets."velocity/forwarding.secret" = {
    owner = "velocity";
    group = "velocity-secret";
    mode = "440";
  };

  networking.firewall = {
    allowedTCPPorts = [ 10000 ];
    allowedUDPPorts = [ 19132 ]; # for geyser
  };

  users = {
    users.velocity = {
      group = "velocity";
      isSystemUser = true;
    };
    groups.velocity = {};
  };

  environment.etc."velocity/velocity.toml".source = pkgs.writers.writeTOML "velocity.toml" {
    config-version = "2.7";

    bind = "0.0.0.0:10000";

    motd = "if you see this the server is not working";
    show-max-players = 2147483647;

    online-mode = true;
    force-key-authentication = false;

    prevent-client-proxy-connections = false;

    player-info-forwarding-mode = "modern";
    forwarding-secret-file = config.sops.secrets."velocity/forwarding.secret".path;

    announce-forge = false;

    kick-existing-players = false;

    ping-passthrough = "ALL";
    sample-players-in-ping = false;

    enable-player-address-logging = true;

    servers = {
      monifactory = "127.0.0.1:10001";
      countries = "127.0.0.1:10002";

      try = [
        "monifactory"
        "countries"
      ];
    };

    forced-hosts = {
      "moni.mc.wo2wz.fyi" = [ "monifactory" ];
      "countries.mc.wo2wz.fyi" = [ "countries" ];
    };
    
    advanced = {
      compression-threshold = 256;
      compression-level = -1;

      connection-timeout = 5000;
      read-timeout = 30000;

      haproxy-protocol = false;
      tcp-fast-open = true;

      bungee-plugin-message-channel = true;

      show-ping-requests = false;

      failover-on-unexpected-server-disconnect = true;

      announce-proxy-commands = true;

      log-command-executions = false;
      log-player-connections = true;

      accepts-transfers = false;

      enable-reuse-port = false;

      login-ratelimit = 3000;
      command-rate-limit = 50;
      forward-commands-if-rate-limited = true;
      kick-after-rate-limited-commands = 0;
      tab-complete-rate-limit = 10;
      kick-after-rate-limited-tab-completes = 0;
    };

    query = {
      enabled = false;
      port = 25565;
      map = "Velocity";
      show-plugins = false;
    };
  };

  systemd.services.velocity = {
    description = "Velocity proxy for Minecraft servers";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      User = "velocity";
      Group = "velocity";
      StateDirectory = "velocity";
      StateDirectoryMode = "0700";
      WorkingDirectory = "%S/velocity";
      # velocity doesnt have a --config :(
      BindReadOnlyPaths = "/etc/velocity/velocity.toml:%S/velocity/velocity.toml";


      ExecStart = lib.concatStringsSep " " [
        "${lib.getExe inputs.nixpkgs-pin.legacyPackages.${pkgs.stdenv.hostPlatform.system}.graalvm-ce}"
        "-Xmx1G -Xms1G -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15"
        "-Dvelocity.max-known-packs=264"
        "-jar ${pkgs.velocity}/share/velocity/velocity.jar"
      ];
      Type = "exec";
      Restart = "always";

      # hardening
      CapabilityBoundingSet = [ "" ];
      DeviceAllow = [ "" ];
      DevicePolicy = "closed";
      LockPersonality = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      PrivateUsers = true;
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RemoveIPC = true;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" ];
      UMask = "0077";
    };
  };
}
