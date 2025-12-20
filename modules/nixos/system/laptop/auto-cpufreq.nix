{ config, ... }:

{
  services = {
    tlp.enable = false;
    power-profiles-daemon.enable = false;
  };

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        energy_performance_preference = "power";
        platform_profile = "cool";
        turbo = "never";

        enable_thresholds = true;
        start_threshold = 50;
        stop_threshold = 80;
      };
      charger = {
        governor = "performance";
        energy_performance_preference = "performance";
        platform_profile = "performance";
        turbo = "auto";
      };
    };
  };
}
