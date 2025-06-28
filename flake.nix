{
  inputs = {
	  nixpkgs.url = "github.com:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest"
      inputs.nixpkgs.follows = "nixpkgs";
    }
  };

  outputs = { self, disko, nixpkgs, home-manager, ...}@inputs: {
    nixosConfigurations.watty-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPackages = true;
          home-manager.useUserPackages = true;
          home-manager.users.emelie = import ./home.nix;
        }
        disko.nixosModules.disko
        {
          disko.devices = {
            disk = {
              main = {
                # When using disko-install, we will overwrite this value from the commandline
                device = "/dev/disk/by-id/some-disk-id";
                type = "disk";
                content = {
                  type = "gpt";
                  partitions = {
                    ESP = {
                      type = "EF00";
                      size = "1G";
                      label = "EFI";
                      name = "ESP";
                      content = {
                        type = "filesystem";
                        format = "vfat";
                        mountpoint = "/boot";
                        mountOptions = [ "umask=0077" "default" ];
                      };
                    };
                    root = {
                      size = "100%";
                      content = {
                        type = "filesystem";
                        format = "ext4";
                        mountpoint = "/";
                      };
                    };
                  };
                };
              };
            };
          };
        }
      ];
    };
  };
}
