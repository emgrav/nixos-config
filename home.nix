{ config, pkgs, lib, ... }:
{
  home.username = "emelie";
  home.homeDirectory = lib.mkDefault "/home/emelie";

  home.packages = with pkgs; [
    neovim
    neovide
    ripgrep
    bitwarden-desktop
    musescore
    muse-sounds-manager
    # unfree
    bitwig-studio
  ];

  home.shell.enableFishIntegration = true;
  home.stateVersion = "25.05";

 wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      input."*" = {
        xkb_layout = "us";
        #xkb_variant = "workman";
        xkb_options = "caps:swapescape";
      };
    };
  };

  programs = {
    firefox.enable = true; 
    alacritty.enable = true;
    fish.enable = true;
    rofi.enable = true;
    helix = {
      enable = true;
      settings.editor.lsp.display-messages = true;
      languages.language-server.rust-analyzer.config.check.command = "clippy";
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      userName = "Emelie Graven";
      userEmail = "emelie@graven.se";
      lfs.enable = true;
      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "nvim";
        push.autoSetupRemote = true;
      };
    };
  };
}
