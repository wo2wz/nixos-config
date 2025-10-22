{ config, pkgs, lib, ... }:

{
  home-manager.users.wo2w = {
    home.packages = [ pkgs.swaybg ];

    systemd.user.services.swaybg = {
      Install.WantedBy = [ "graphical-session.target" ];

      Service = {
        ExecStart = ''
          ${lib.getExe pkgs.swaybg} -o eDP-1 -i /home/wo2w/Pictures/Wallpapers/oneshot1.png -m fill \
          -o DP-1 -i /home/wo2w/Pictures/Wallpapers/oneshot1.png -m fill \
          -o DP-2 -i /home/wo2w/Pictures/Wallpapers/oneshot2.png -m fill
        '';
        Restart = "always";
      };

      Unit = {
        Description = "Custom user service for swaybg";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
    };
  };
}