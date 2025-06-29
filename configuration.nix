{ pkgs, flake-inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  users.defaultUserShell = pkgs.fish;
  users.users.emelie = {
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
