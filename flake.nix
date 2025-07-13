{
  description = "GraalVM Java 17/21, Spotify, and Home Manager";

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

      # define overlays
      nixpkgs-pin-overlay = final: prev: {
        nixpkgs-pin = nixpkgs-pin.legacyPackages.${prev.system};
      };

      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in {
      nixosConfigurations.Ares = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # make nixpkgs-pin and unstable available in configuration.nix
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ nixpkgs-pin-overlay ]; })
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })

          ./hardware-configuration.nix
          ./configuration.nix
          
          nixos-hardware.nixosModules.dell-xps-15-9570-nvidia
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix

          {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.wo2w = import ./home.nix;
            backupFileExtension = "bak";
            extraSpecialArgs = { inherit inputs; };
          };
          }
        ];
      };
  };
}
