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
    extraGroups = [ "wheel" "networkmanager" ];
  };
  users.groups.emelie = {};

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.lix;

    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://cache.nixos.org" "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    };

    gc = {
      automatic = true;
      dates = "Thu";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking = {
    hostName = "watty-nixos";
    networkmanager.enable = true;
  };
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


  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      #variant = "workman";
      options = "caps:swapescape";
    };
  };

  console.useXkbConfig = true;

  system.stateVersion = "25.05";
}
