{ config, pkgs, lib, ... }:

{
  sops.secrets."restic/password" = {};

  systemd.services = {
    db-backup = {
      wantedBy = [ "restic-backups-main.service" ];
      before = [ "restic-backups-main.service" ];
      script = ''
        DB_BACKUP_DIR=/var/backups/db-backup

        SQLITE_PATH=${lib.getExe pkgs.sqlite}
        SUDO_PATH=${lib.getExe pkgs.sudo}

        if [ ! -d $DB_BACKUP_DIR ]; then
            mkdir -p -m 600 $DB_BACKUP_DIR
        fi

        umask 077

        $SQLITE_PATH /var/lib/vaultwarden/db.sqlite3 ".backup $DB_BACKUP_DIR/vaultwarden.sqlite3"
        $SQLITE_PATH /var/lib/uptime-kuma/kuma.db ".backup $DB_BACKUP_DIR/kuma.db"
        $SQLITE_PATH /var/lib/nextcloud/data/nextcloud.db ".backup $DB_BACKUP_DIR/nextcloud.db"
        $SQLITE_PATH /var/lib/ntfy-sh/user.db ".backup $DB_BACKUP_DIR/ntfy-user.db"
        $SQLITE_PATH /var/lib/kanidm/kanidm.db ".backup $DB_BACKUP_DIR/kanidm.db"
        $SQLITE_PATH /var/lib/jellyfin/data/jellyfin.db ".backup $DB_BACKUP_DIR/jellyfin.db"
        $SQLITE_PATH /var/lib/jellyfin/data/library.db ".backup $DB_BACKUP_DIR/jellyfin-library.db"
        $SQLITE_PATH /var/lib/grafana/data/grafana.db ".backup $DB_BACKUP_DIR/grafana.db"
      '';
      serviceConfig.Type = "oneshot";
    };

    db-backup-cleanup = {
      wantedBy = [ "restic-backups-main.service" ];
      after = [ "restic-backups-main.service" ];
      script = "rm -r /var/backups/db-backup";
      serviceConfig.Type = "oneshot";
    };

    restic-backups-main.serviceConfig.Type = "oneshot";
  };

  services.restic.backups = {
    main = {
      user = "restic";
      package = pkgs.writeShellScriptBin "restic" ''
         exec /run/wrappers/bin/restic "$@"
      '';

      initialize = true;
      repository = "/mnt/external/backup/restic";
      passwordFile = config.sops.secrets."restic/password".path;
      timerConfig = {
        OnCalendar = "03:00";
        Persistent = true;
      };

      paths = [
        "/var/lib/jellyfin"
        "/var/lib/vaultwarden"
        "/var/backups/db-backup"
      ];

      # exclude databases since they are covered separately
      exclude = [
        "/var/lib/**/*.db"
        "/var/lib/**/*.db-shm"
        "/var/lib/**/*.db-wal"
        "/var/lib/**/*.sqlite3"
        "/var/lib/**/*.sqlite3-shm"
        "/var/lib/**/*.sqlite3-wal"

        "/var/lib/vaultwarden/sends/*"
        "/var/lib/vaultwarden/tmp/*"
      ];
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
