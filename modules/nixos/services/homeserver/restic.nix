{ config, pkgs, lib, ... }:

{
  sops.secrets."restic/password" = {};

  # for use as restic backend
#  environment.systemPackages = [ pkgs.rclone ];

  systemd.services.db-dump = {
    wantedBy = [ "restic-backups-main.service" "restic-backups-offsite.service" ];
    script = ''
      if [ ! -d /var/backups/db-backup ]; then
          mkdir -p -m 600 /var/backups/db-backup
      fi

      ${lib.getExe pkgs.sqlite} /var/lib/vaultwarden/db.sqlite3 ".backup /var/backups/db-backup/vaultwarden.sqlite3"
      ${lib.getExe pkgs.sqlite} /var/lib/uptime-kuma/kuma.db ".backup /var/backups/db-backup/kuma.db"
      ${lib.getExe pkgs.sqlite} /var/lib/nextcloud/data/nextcloud.db ".backup /var/backups/db-backup/nextcloud.db"
      ${lib.getExe pkgs.sqlite} /var/lib/ntfy-sh/user.db ".backup /var/backups/db-backup/ntfy-user.db"

      ${lib.getExe pkgs.sudo} -u onlyoffice -- ${lib.getExe' pkgs.postgresql "pg_dump"} > /var/backups/db-backup/dump-onlyoffice
      ${lib.getExe pkgs.sudo} -u zipline -- ${lib.getExe' pkgs.postgresql "pg_dump"} > /var/backups/db-backup/dump-zipline
      ${lib.getExe pkgs.sudo} -u postgres -- ${lib.getExe' pkgs.postgresql "pg_dumpall"} -g > /var/backups/db-backup/dump-globals      
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  services.restic.backups = {
    main = {
      initialize = true;
      repository = "/mnt/external/backup/restic";
      passwordFile = config.sops.secrets."restic/password".path;
      timerConfig = {
        OnCalendar = "03:00";
        Persistent = true;
      };

      paths = [
        "/var/lib/private/uptime-kuma"
        "/var/lib/nextcloud"
        "/var/lib/vaultwarden"
        "/var/backups/db-backup"
      ];
      # exclude databases since they are covered separately
      exclude = [
        "*.db"
        "*.db-shm"
        "*.db-wal"
        "*.sqlite3"
        "*.sqlite3-shm"
        "*.sqlite3-wal"
      ];

      backupCleanupCommand = "rm -r /var/backups/db-backup/*";
    };

#    offsite = {
#      initialize = true;
#      repository = "rclone:protondrive:restic";
#      passwordFile = config.sops.secrets."restic/password".path;
#      timerConfig = {
#        OnCalendar = "3:05";
#        Persistent = true;
#      };
#      rcloneOptions = { protondrive-replace-existing-draft = true; };
#      rcloneConfigFile = config.sops.secrets."restic/rclone/offsite".path;

#      paths = config.services.restic.backups.main.paths;
#      exclude = config.services.restic.backups.main.exclude;

#      backupCleanupCommand = "rm -r /var/backups/db-backup/*";
#    };
  };
}
