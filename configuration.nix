# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  # pin the latest nvidia driver that works because they are so awesome in releasing an update that broke opengl for my 1050ti
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "570.144";
    sha256_64bit = "sha256-wLjX7PLiC4N2dnS6uP7k0TI9xVWAJ02Ok0Y16JVfO+Y=";
    sha256_aarch64 = "sha256-6kk2NLeKvG88QH7/YIrDXW4sgl324ddlAyTybvb0BP0=";
    openSha256 = "sha256-PATw6u6JjybD2OodqbKrvKdkkCFQPMNPjrVYnAZhK/E=";
    settingsSha256 = "sha256-VcCa3P/v3tDRzDgaY+hLrQSwswvNhsm93anmOhUymvM=";
    persistencedSha256 = "sha256-hx4w4NkJ0kN7dkKDiSOsdJxj9+NZwRsZEuhqJ5Rq3nM=";
  };

  # enable yubikey auth
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    sddm = {
      u2fAuth = true;
      kwallet.enable = true;
    };
    kde.u2fAuth = true;
    # kde popups
    polkit-1.u2fAuth = true;
  };

  # Bootloader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
  };

  # swap
  swapDevices = [ {
    device = "/var/swapfile";
    size = 16*1024;
  } ];

  # systemd timers
  systemd.timers = {
    "autoUpgrade" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 3:30:00";
        Unit = "autoUpgrade.service";
      };
    };

#    "rsync" = {
#      wantedBy = [ "timers.target" ];
#      timerConfig = {
#        OnCalendar = "*-*-* 4:00:00";
#        Unit = "rsync.service";
#      };
#    };
  };

  systemd.services = {
#    "rsync" = {
#      script = '' ${pkgs.bash}/bin/bash /home/wo2w/Scripts/rsync.sh '';
#      serviceConfig = {
#        Type = "oneshot";
#        User = "root";
#      };
#    };

    "autoUpgrade" = {
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      script = '' /usr/bin/env -C /etc/nixos ${pkgs.nix}/bin/nix flake update '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };

  # nix config
  nix = {
    gc.automatic = true;
    optimise.automatic = true;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      download-buffer-size = 524288000;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "Ares"; # Define your hostname.
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Location (real)
  location = {
    latitude = 71.8260798;
    longitude = 91.0350983;
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
      compositor = "kwin";
    };
  };
  services.desktopManager.plasma6.enable = true;
  programs.niri.enable = true;
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable sound with pipewire. + bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # libratbag for mouse config
  services.ratbagd.enable = true;

  users.users.wo2w = {
    isNormalUser = true;
    description = "Ares";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # utilities
    wget
    xautomation
    cameractrls
    kdePackages.ksshaskpass
    # for niri
    fuzzel
    mako
    waybar
    xwayland-satellite
#   gamemode
#   adb
#   ratbagd
    # graphical applications
#   adb
#   steam
#   kdeconnect
  ];

  # exclude some kde packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    discover
    konsole
    khelpcenter
    krdp
  ];

  programs = {
    adb.enable = true;
    gamemode.enable = true;
    kdeconnect.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    targets = {
      fontconfig.enable = false;
      font-packages.enable = false;
    };
    fonts.sizes = {
      applications = 12;
      desktop = 10;
      popups = 10;
      terminal = 12;
    };
  };

  services = {
    # CUPS for printing
    printing.enable = true;
  };

  # enable native wayland in chromium/electron
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # ssh
  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    extraConfig = "
      Host gameserver
        Hostname 192.168.2.221
        Port 22
        User wo2w
        IdentityFile /home/wo2w/.ssh/ssh-key
    ";
  };

  environment.variables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
