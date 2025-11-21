{ inputs, config, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;

    age.keyFile = "/root/.config/sops/age/keys.txt";
  };
}
