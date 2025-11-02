{ config, pkgs, lib, ... }:

{
  sops.secrets."restic/password" = {};

  # for use as restic backend
#  environment.systemPackages = [ pkgs.rclone ];

  systemd.services.db-backup = {
    wantedBy = [ "restic-backups-main.service" "restic-backups-offsite.service" ];
    script = ''
      DB_BACKUP_DIR=/var/backups/db-backup

      SQLITE_PATH=${lib.getExe pkgs.sqlite}
      SUDO_PATH=${lib.getExe pkgs.sudo}
      PGDUMP_PATH=${lib.getExe' pkgs.postgresql "pg_dump"}

      if [ ! -d $DB_BACKUP_DIR ]; then
          mkdir -p -m 600 $DB_BACKUP_DIR
      fi

      $SQLITE_PATH /var/lib/vaultwarden/db.sqlite3 ".backup $DB_BACKUP_DIR/vaultwarden.sqlite3"
      $SQLITE_PATH /var/lib/uptime-kuma/kuma.db ".backup $DB_BACKUP_DIR/kuma.db"
      $SQLITE_PATH /var/lib/nextcloud/data/nextcloud.db ".backup $DB_BACKUP_DIR/nextcloud.db"
      $SQLITE_PATH /var/lib/ntfy-sh/user.db ".backup $DB_BACKUP_DIR/ntfy-user.db"

      $SUDO_PATH -u onlyoffice -- $PGDUMP_PATH > /var/backups/db-backup/dump-onlyoffice
      $SUDO_PATH -u zipline -- $PGDUMP_PATH > /var/backups/db-backup/dump-zipline
      $SUDO_PATH -u postgres -- ${lib.getExe' pkgs.postgresql "pg_dumpall"} -g > /var/backups/db-backup/dump-globals      
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
