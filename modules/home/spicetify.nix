{ inputs, config, pkgs, ... }:

{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify =
  let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
  in {
    enable = true;
    theme = {
      name = "Tokyo";
      src = pkgs.fetchFromGitHub {
        owner = "evening-hs";
        repo = "Spotify-Tokyo-Night-Theme";
        rev = "d88ca06eaeeb424d19e0d6f7f8e614e4bce962be";
        hash = "sha256-cLj9v8qtHsdV9FfzV2Qf4pWO8AOBXu51U/lUMvdEXAk=";
      };
    };
    colorScheme = "Night";
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle
      volumePercentage
      history
    ];
  };
}