{
  description = "all this does now is pass inputs to other modules and set the system variable";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-pin.url = "github:NixOS/nixpkgs/336eda0d07dc5e2be1f923990ad9fdb6bc8e28e3";

    authentik-nix.url = "github:nix-community/authentik-nix";

    nixos-avf = {
      url = "github:nix-community/nixos-avf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ ... }:
    let
      system = inputs.nixpkgs.lib.mkDefault "x86_64-linux";
      nixosSystem =
        hostName:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit hostName inputs system; };
          modules = [ ./hosts/${hostName} ];
        };
    in {
      nixosConfigurations = {
        Swordsmachine = nixosSystem "Swordsmachine";
        Earthmover = nixosSystem "Earthmover";
        Drone = nixosSystem "Drone";
        Mindflayer = nixosSystem "Mindflayer";
      };
  };
}
