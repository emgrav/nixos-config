{ pkgs, flake-inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  users.users.emelie.shell = pkgs.fish;
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "watty-nixos";
  time.timeZone = "Europe/Copenhagen";
  
  programs = {
    fish.enable = true;
  };

  system.stateVersion = "25.05";
}
