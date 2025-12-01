{ inputs, config, ... }:

{
  imports = [
    ../../modules/common/locales.nix
    ../../modules/common/nix.nix
    ../../modules/common/users.nix

    inputs.nixos-avf.nixosModules.avf
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "25.05";
}