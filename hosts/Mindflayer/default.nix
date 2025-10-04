{ inputs, config, ... }:

{
  imports = [
    ../../common/locales.nix
    ../../common/nix.nix
    ../../common/users.nix

    inputs.nixos-avf.nixosModules.avf
  ];

  networking.hostName = "Mindflayer";

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "25.05";
}