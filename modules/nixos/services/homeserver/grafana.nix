{ config, pkgs, ... }:

{
  sops.secrets."grafana/secrets.env" = {};

  services.caddy.virtualHosts."grafana.taild5f7e6.ts.net".extraConfig =
  assert config.services.caddy.enable;
  ''
    import default-settings

    bind tailscale/grafana

    reverse_proxy localhost:${toString config.services.grafana.settings.server.http_port}
  '';

  systemd.services.grafana.serviceConfig.EnvironmentFile = config.sops.secrets."grafana/secrets.env".path;

  services.grafana = {
    enable = true;
    settings = {
      server = {
        domain = "grafana.taild5f7e6.ts.net";
        root_url = "https://grafana.taild5f7e6.ts.net/";
        enforce_domain = true;
        http_addr = "127.0.0.1";
        http_port = 9001;

        enable_gzip = true;
      };

      security = {
        secret_key = "$__env{GRAFANA_SECRET_KEY}";
        cookie_secure = true;
        disable_gravatar = true;
      };

      analytics = {
        reporting_enabled = false;
        feedback_links_enabled = false;
      };
    };

    provision = {
      enable = true;

      dashboards.settings.providers = [
        {
          name = "Node Exporter Full";
          disableDeletion = true;
          options.path = builtins.fetchurl {
            url = "https://grafana.com/api/dashboards/1860/revisions/42/download";
            name = "node-exporter-full.json";
            sha256 = "sha256:0phjy96kq4kymzggm0r51y8i2s2z2x3p69bd5nx4n10r33mjgn54";
          };
        }
      ];

      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://127.0.0.1:${toString config.services.prometheus.port}";
        }
      ];
    };
  };

  services.caddy.virtualHosts."prometheus.taild5f7e6.ts.net".extraConfig =
  assert config.services.caddy.enable;
  ''
    import default-settings

    bind tailscale/prometheus

    reverse_proxy localhost:${toString config.services.prometheus.port}
  '';

  services.prometheus = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = 9000;
    webExternalUrl = "https://prometheus.taild5f7e6.ts.net";

    globalConfig.scrape_interval = "10s";

    exporters.node = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = 9002;
      enabledCollectors = [ "systemd" "processes" ];
    };

    scrapeConfigs = [
      {
        job_name = "Node exporter";
        static_configs = [
          {
            targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
          }
        ];
      }
    ];
  };
}
