{ config, ... }:

{
  services.zfs.zed.settings = {
    ZED_SCRUB_AFTER_RESILVER = true;

    # TODO seemingly impossible to pass access token to zed without exposing it in plaintext so i guess this wont do
#    ZED_NOTIFY_VERBOSE = true;
#    ZED_NTFY_URL = "https://ntfy.taild5f7e6.ts.net";
#    ZED_NTFY_TOPIC = "ZED";
  };
}
