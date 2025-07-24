{ config, ... }:

{
  nix = {
    channel.enable = false;
    gc.automatic = true;
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      download-buffer-size = 524288000;
    };
  };

  nixpkgs.config.allowUnfree = true;
}