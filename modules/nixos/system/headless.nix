{ config, ... }:

{
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/profiles/headless.nix

  systemd.services = {
    "serial-getty@ttyS0".enable = false;
    "serial-getty@hvc0".enable = false;
    "getty@tty1".enable = false;
    "autovt@".enable = false;
  };

  boot.kernelParams = [
    "panic=1"
    "boot.panic_on_fail"
    "vga=0x317"
    "nomodeset"
  ];
  
  systemd.enableEmergencyMode = false;
}