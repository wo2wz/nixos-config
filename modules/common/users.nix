{ hostName, config, ... }:

{
  users.users.wo2w = {
    isNormalUser = true;
    description = "${hostName}";
    extraGroups = [ "networkmanager" "wheel" ];

    # make new user logins (iso/vm/new machine) use a default password
    initialPassword = "1234";
  };
}