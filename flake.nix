{
  description = "all this does now is pass inputs to other modules and set the system variable";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-pin.url = "github:NixOS/nixpkgs/336eda0d07dc5e2be1f923990ad9fdb6bc8e28e3";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-pin,
      nixos-hardware,
      home-manager,
      stylix,
      ...
    }@inputs:
    let      
      system = "x86_64-linux";
      nixosSystem =
        hostName:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit hostName inputs system; };
          modules = [ ./hosts/${hostName} ];
        };
    in {
      nixosConfigurations = {
        Swordsmachine = nixosSystem "Swordsmachine";
        Earthmover = nixosSystem "Earthmover";
      };
  };
}
