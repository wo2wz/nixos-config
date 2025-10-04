{ config, lib, ... }:

{
  environment.defaultPackages = lib.mkForce [];
}