{ config, ... }:

{
  sops.defaultSopsFile = "/etc/nixos/secrets/drone.yaml";
}