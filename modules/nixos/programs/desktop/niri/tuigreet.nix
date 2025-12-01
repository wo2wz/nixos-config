{ config, lib, pkgs, ... }:

{
  services = {
    displayManager.sddm = {
      enable = lib.mkForce false;
      wayland.enable = lib.mkForce false;
    };

    greetd = {
      enable = true;
      settings.default_session = {
        command = ''
        ${lib.getExe pkgs.tuigreet} \
        --cmd niri-session \
        --power-shutdown poweroff \
        --power-reboot reboot \
        --remember \
        --asterisks \
        --time \
        --greeting "${config.networking.hostName} | Collect my sessions..."
        '';
        user = "greeter";
      };
    };
  };
}