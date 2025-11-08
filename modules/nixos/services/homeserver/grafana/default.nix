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

      "auth.generic_oauth" = {
        enabled = true;
        name = "Kanidm";
        client_id = "grafana";
        auth_url = "https://kanidm.wo2wz.fyi/ui/oauth2";
        token_url = "https://kanidm.wo2wz.fyi/oauth2/token";
        api_url = "https://kanidm.wo2wz.fyi/oauth2/openid/grafana/userinfo";

        scopes = [ "openid" "profile" "email" "groups" "offline_access" ];
        login_attribute_path = "preferred_username";
        email_attribute_path = "email";
        groups_attribute_path = "groups";
        role_attribute_path = "contains(grafana_users[*], 'GrafanaAdmin') && 'GrafanaAdmin' || 'Viewer'";
        allow_assign_grafana_admin = true;

        allow_sign_up = true;
        use_pkce = true;
        use_refresh_token = true;
      };

      security = {
        secret_key = "$__env{GRAFANA_SECRET_KEY}";
        disable_initial_admin_creation = true;
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
          options.path = ./dashboards/node-exporter-full.json;
          disableDeletion = true;
        }
        {
          name = "Caddy";
          options.path = ./dashboards/caddy.json;
          disableDeletion = true;
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
      {
        job_name = "Caddy";
        static_configs = [
          {
            targets = [ "localhost:2019" ];
          }
        ];
      }
    ];
  };
}
