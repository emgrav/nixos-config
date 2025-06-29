{ config, pkgs, ... }:

{

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false<;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };

