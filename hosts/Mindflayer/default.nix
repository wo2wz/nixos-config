{ inputs, config, ... }:

{
  imports = [
    ../../modules/common/debloat.nix
    ../../modules/common/locales.nix
    ../../modules/common/nix.nix
    ../../modules/common/users.nix

    ../../modules/nixos/programs/bash.nix
    ../../modules/nixos/programs/git.nix

    inputs.nixos-avf.nixosModules.avf
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "25.05";
}