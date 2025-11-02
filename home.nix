{
  config,
  pkgs,
  lib,
  ...
}: {
  home.username = "emelie";
  home.homeDirectory = lib.mkDefault "/home/emelie";

  home.file = {
    ".ssh/allowed_signers".text = "emelie@graven.se namespaces=\"git\" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAn9xV1GA/hMkCFoP7DWzYyGmbeiri823fHMRz0ZVoxq";
  };

  home.packages = with pkgs; [
    neovim
    neovide
    ripgrep
    bitwarden-desktop
    musescore
    muse-sounds-manager
    element-desktop
    nixfmt-rfc-style
    alejandra
    # unfree
    bitwig-studio
    discord
  ];

  home.shell.enableFishIntegration = true;
  home.sessionVariables = {
    SSH_AUTH_SOCK = "/home/emelie/.bitwarden-ssh-agent.sock";
  };
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
  services = {
    gnome-keyring = {
      enable = true;
      components = ["secrets"];
    };
    swayidle = let
      # Lock command
      lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
      # TODO: modify "display" function based on your window manager
      # Sway
      display = status: "swaymsg 'output * power ${status}'";
      # Hyprland
      # display = status: "hyprctl dispatch dpms ${status}";
      # Niri
      # display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
    in {
      enable = true;
      timeouts = [
        {
          timeout = 180; # in seconds
          command = "${pkgs.libnotify}/bin/notify-send 'Locking in 10 seconds' -t 10000";
        }
        {
          timeout = 190;
          command = lock;
        }
        {
          timeout = 200;
          command = display "off";
          resumeCommand = display "on";
        }
        {
          timeout = 600;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = [
        {
          event = "before-sleep";
          # adding duplicated entries for the same event may not work
          command = (display "off") + "; " + lock;
        }
        {
          event = "after-resume";
          command = display "on";
        }
        {
          event = "lock";
          command = (display "off") + "; " + lock;
        }
        {
          event = "unlock";
          command = display "on";
        }
      ];
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
      signing = {
        key = "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAn9xV1GA/hMkCFoP7DWzYyGmbeiri823fHMRz0ZVoxq";
        signByDefault = true;
        format = "ssh";
      };
      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "hx";
        push.autoSetupRemote = true;
        gpg.ssh.allowedSignersFile = "/home/emelie/.ssh/allowed_signers";
      };
    };
  };
}
