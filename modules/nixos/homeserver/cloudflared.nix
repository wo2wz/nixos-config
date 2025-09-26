{ config, ... }:

{
  services.cloudflared = {
    enable = true;
    tunnels."8af2892d-d534-4e32-b867-5b79308a99d5" = {
      credentialsFile = config.sops.secrets."cloudflared/8af2892d-d534-4e32-b867-5b79308a99d5.json".path;
      default = "http_status:418";
    };
  };
}
