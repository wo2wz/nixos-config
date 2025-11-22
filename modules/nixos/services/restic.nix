{ config, pkgs, lib, ... }:

{
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
}