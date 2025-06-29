{ pkgs, flake-inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  users.defaultUserShell = pkgs.fish;
  users.users.emelie = {
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
  };

  system.stateVersion = "25.05";
}
