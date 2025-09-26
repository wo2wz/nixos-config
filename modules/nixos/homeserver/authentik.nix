{ inputs, config, ... }:

{
  imports = [ inputs.authentik-nix.nixosModules.default ];
  nix.settings = {
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };

  services.authentik = {
    enable = true;
    environmentFile = config.sops.secrets."authentik/secrets.env".path;

    settings = {
      disable_startup_analytics = true;
      disable_update_check = true;
      avatars = "initials";
    };
  };
}
