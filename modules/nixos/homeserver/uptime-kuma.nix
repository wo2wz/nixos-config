{ config, ... }:

{
  services.uptime-kuma = {
    enable = true;
    settings.PORT = "8005";
  };
}
