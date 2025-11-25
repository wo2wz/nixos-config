{
  description = "My configuration(s) for the NixOS Linux Distribution";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-pin.url = "github:NixOS/nixpkgs/336eda0d07dc5e2be1f923990ad9fdb6bc8e28e3";

    nixos-avf = {
      url = "github:nix-community/nixos-avf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ ... }:
    let
      system = inputs.nixpkgs.lib.mkDefault "x86_64-linux";
      mkHost =
        hostName:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs system; };
          modules = [
            { networking.hostName = hostName; }
            ./hosts/${hostName}
          ];
        };
    in {
      nixosConfigurations = {
        Swordsmachine = mkHost "Swordsmachine";
        Earthmover = mkHost "Earthmover";
        Drone = mkHost "Drone";
        Mindflayer = mkHost "Mindflayer";
        Gutterman = mkHost "Gutterman";
      };
  };
}
