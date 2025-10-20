{ config, pkgs, ... }:

{
  programs.librewolf = {
    enable = true;
    settings = {
      "identity.fxaccounts.enabled" = true;

      "privacy.resistFingerprinting" = false;
      "privacy.fingerprintingProtection" = true;
      "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";
      "webgl.disabled" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "privacy.clearOnShutdown.downloads" = true;
      "privacy.clearOnShutdown.history" = false;

      "clipboard.autocopy" = false;
    };
    policies = {
      DefaultDownloadDirectory = "/home/wo2w/Downloads";

      ExtensionSettings = with builtins; let
        extension = shortId: uuid: {
          name = uuid;
          value = {
            install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
            installation_mode = "normal_installed";
          };
        };
      in
        listToAttrs [
          (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
          (extension "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
          (extension "darkreader" "addon@darkreader.org")
          (extension "decentraleyes" "jid1-BoFifL9Vbdl2zQ@jetpack")
          (extension "happy-bonobo-disable-webrtc" "jid1-5Fs7iTLscUaZBgwr@jetpack")
          (extension "enhancer-for-youtube" "enhancerforyoutube@maximerf.addons.mozilla.org")
          (extension "indie-wiki-buddy" "{cb31ec5d-c49a-4e5a-b240-16c767444f62}")
          (extension "libredirect" "7esoorv3@alefvanoon.anonaddy.me")
          (extension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
          (extension "return-youtube-dislikes" "{762f9885-5a13-4abd-9c77-433dcd38b8fd}")
          (extension "ublock-origin" "uBlock0@raymondhill.net")
        ];
    };
    profiles.wo2w = {
      search = {
        force = true;
        default = "ddg";
        privateDefault = "ddg";
      };
      settings = {
        "browser.urlbar.suggest.history" = true;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.suggest.recentsearches" = false;
        # remember tabs on startup
        "browser.startup.page" = 3;

        # encrypted dns
        "network.trr.mode" = 2;
        "network.trr.uri" = "https://base.dns.mullvad.net/dns-query";
        "network.trr.custom_uri" = "https://base.dns.mullvad.net/dns-query";

        "privacy.clearHistory.formdata" = true;
        "privacy.clearHistory.siteSettings" = false;
        "privacy.clearOnShutdown.cache" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown.sessions" = false;
        "privacy.donottrackheader.enabled" = true;

        # use xdg file picker instead of builtin browser picker
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
  };
}