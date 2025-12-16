{ config, pkgs, ... }:

{
  sops.secrets = {
    "restic/password" = {};
    "restic/rest-auth.env" = {};
  };

  services.restic.backups.gameservers =
  assert config.users.users.restic-backup != null;
  {
    user = "restic-backup";
    package = pkgs.writeShellScriptBin "restic" ''
      exec /run/wrappers/bin/restic "$@"
    '';

    environmentFile = config.sops.secrets."restic/rest-auth.env".path;
    passwordFile = config.sops.secrets."restic/password".path;
    timerConfig = {
      OnCalendar = "03:00";
      Persistent = true;
    };

    repository = "rest:https://restic.taild5f7e6.ts.net/gutterman/gameservers";
    initialize = true;

    paths = [
      "/var/lib/minecraft"
    ];
    exclude = [ ".*" ];
  };
}