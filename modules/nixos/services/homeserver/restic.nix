{ config, pkgs, lib, ... }:

{
  sops.secrets."restic/password" = {};

  # for use as restic backend
#  environment.systemPackages = [ pkgs.rclone ];

  systemd.services = {
    db-backup = {
      wantedBy = [ "restic-backups-main.service" ];
      before = [ "restic-backups-main.service" ];
      script = ''
        DB_BACKUP_DIR=/var/backups/db-backup

        SQLITE_PATH=${lib.getExe pkgs.sqlite}
        SUDO_PATH=${lib.getExe pkgs.sudo}
        PGDUMP_PATH=${lib.getExe' pkgs.postgresql "pg_dump"}

        if [ ! -d $DB_BACKUP_DIR ]; then
            mkdir -p -m 600 $DB_BACKUP_DIR
        fi

        umask 077

        $SQLITE_PATH /var/lib/vaultwarden/db.sqlite3 ".backup $DB_BACKUP_DIR/vaultwarden.sqlite3"
        $SQLITE_PATH /var/lib/uptime-kuma/kuma.db ".backup $DB_BACKUP_DIR/kuma.db"
        $SQLITE_PATH /var/lib/nextcloud/data/nextcloud.db ".backup $DB_BACKUP_DIR/nextcloud.db"
        $SQLITE_PATH /var/lib/ntfy-sh/user.db ".backup $DB_BACKUP_DIR/ntfy-user.db"
        $SQLITE_PATH /var/lib/kanidm/kanidm.db ".backup $DB_BACKUP_DIR/kanidm.db"

        $SUDO_PATH -u onlyoffice -- $PGDUMP_PATH > $DB_BACKUP_DIR/dump-onlyoffice
        $SUDO_PATH -u zipline -- $PGDUMP_PATH > $DB_BACKUP_DIR/dump-zipline
        $SUDO_PATH -u postgres -- ${lib.getExe' pkgs.postgresql "pg_dumpall"} -g > $DB_BACKUP_DIR/dump-globals
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

  # make wrapper to run restic rootless
  users = {
    users.restic = {
      group = "restic";
      isSystemUser = true;
    };
    groups.restic = {};
  };

  security.wrappers.restic = {
    source = lib.getExe pkgs.restic;
    owner = "restic";
    group = "restic";
    permissions = "500";
    capabilities = "cap_dac_read_search+ep";
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
