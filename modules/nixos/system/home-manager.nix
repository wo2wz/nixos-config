{ inputs, config, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = { inherit inputs; };
    users.wo2w.home = {
      username = "wo2w";
      homeDirectory = "/home/wo2w";
    };
  };
}