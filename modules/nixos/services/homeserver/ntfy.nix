{ config, ... }:

{

  services.caddy.virtualHosts."ntfy.taild5f7e6.ts.net".extraConfig =
  assert config.services.caddy.enable;
  ''
    import default-settings

    bind tailscale/ntfy

    reverse_proxy localhost${config.services.ntfy-sh.settings.listen-http}
  '';

  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://ntfy.taild5f7e6.ts.net";
      listen-http = ":8006";
      behind-proxy = true;
      proxy-trusted-hosts = "127.0.0.1";

      auth-default-access = "deny-all";
      enable-login = true;
      require-login = true;
      auth-access = [
        "*:*:none"
      ];

      attachment-file-size-limit = "20G";
      attachment-total-size-limit = "200G";
    };
  };
}
