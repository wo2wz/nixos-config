{ inputs, config, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = "/etc/nixos/secrets/secrets.yaml";
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;

    age.keyFile = "/root/.config/sops/age/keys.txt";

    secrets = {
      "caddy/wo2wz.fyi.crt" = {
        owner = "caddy";
        group = "caddy";
        reloadUnits = [ "caddy.service" ];
      };
      "caddy/wo2wz.fyi.key" = {
        owner = "caddy";
        group = "caddy";
        reloadUnits = [ "caddy.service" ];
      };

      "cloudflared/8af2892d-d534-4e32-b867-5b79308a99d5.json" = {};

      "nextcloud/adminpass" = {};

      "vaultwarden/secrets.env".restartUnits = [ "vaultwarden.service" ];

      "zipline/secrets.env".restartUnits = [ "zipline.service" ];
    };
  };
}
