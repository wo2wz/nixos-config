{ config, inputs, pkgs, ... }:

{
  services.tailscale.enable = true;
  # fix build failure temporarily
  services.tailscale.package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.tailscale;
}
