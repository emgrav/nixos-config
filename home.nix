{ config, pkgs, lib, ... }:
{
  home.username = "emelie";
  home.homeDirectory = lib.mkDefault "/home/emelie";

  home.packages = with pkgs; [
    neovim
    ripgrep
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
        xkb_variant = "workman";
        xkb_options = "caps:swapescape";
      };
    };
  };

  
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };
  programs.fish = {
    enable = true;
  };
}
