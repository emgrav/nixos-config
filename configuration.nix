{ pkgs, flake-inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  users.defaultUserShell = pkgs.fish;
  users.users.emelie = {
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAn9xV1GA/hMkCFoP7DWzYyGmbeiri823fHMRz0ZVoxq bitwarden" ];
    hashedPassword = "$y$j9T$ln5W/77D9oSZa9upt88EN1$ptJS3ItAcU6kmpe4JxAv73EVBtY3NiqxuB.faRVQeQ4";
    shell = pkgs.fish;
    isNormalUser = true;
    group = "emelie";
    extraGroups = [ "wheel" ];
  };
  users.groups.emelie = {};
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "watty-nixos";
  time.timeZone = "Europe/Copenhagen";
  
  programs = {
    fish.enable = true;
    sway.enable = true;
    uwsm = {
      enable = true;
      waylandCompositors.sway = {
        prettyName = "Sway";
        comment = "Sway compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/sway";
      };
    };
  };


  service

  system.stateVersion = "25.05";
}
