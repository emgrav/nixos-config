{ pkgs, flake-inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    flake-inputs.nixos-hardware.nixosModules.common-pc-laptop
    flake-inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd

    flake-inputs.nixos-hardware.nixosModules.common-cpu-amd
  ];

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      input."*" = {
        xkb_layout = "us";
        xkb_variant = "workman";
        xkb_options = "caps:swapescape";
      };
    };
  };

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
