{ config, pkgs, lib, ... }:

{
  # make wrapper to run restic rootless
  users = {
    users.restic-backup = {
      group = "restic-backup";
      isSystemUser = true;
    };
    groups.restic-backup = {};
  };

  security.wrappers.restic = {
    source = lib.getExe pkgs.restic;
    owner = "restic-backup";
    group = "restic-backup";
    permissions = "500";
    capabilities = "cap_dac_read_search+ep";
  };
}