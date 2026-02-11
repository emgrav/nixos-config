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
    element-desktop
    nixfmt-rfc-style
    alejandra
    monero-gui
    tor-browser
    trezor-suite
    trezor-udev-rules
    audacity
    calibre
    signal-desktop
    direnv
    thunderbird
    wireguard-tools
    wireguard-go
    flameshot
    feishin
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
      keybindings = lib.mkOptionDefault {
        "${modifier}+Shift+4" = ''exec ${pkgs.flameshot}/bin/flameshot gui --clipboard --pin --path ~/Pictures'';
        "${modifier}+Shift+s" = "exec swayidle idlehint 1";
        "${modifier}+Shift+p" = "systemctl poweroff";
      };
      terminal = "alacritty";
      input."*" = {
        xkb_layout = "us";
        #xkb_variant = "workman";
        xkb_options = "caps:escape";
      };
      output."DP-1" = {
        adaptive_sync = "on";
        mode = "3440x1440@164.900Hz";
      };
    };
  };
  services = {
    gnome-keyring = {
      enable = true;
      components = ["secrets"];
    };
    gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-gnome3;
    };
    swayidle = let
      lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
      display = status: "swaymsg 'output * power ${status}'";
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
    gpg.enable = true;
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
      lfs.enable = true;
      signing = {
        key = "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAn9xV1GA/hMkCFoP7DWzYyGmbeiri823fHMRz0ZVoxq";
        signByDefault = true;
        format = "ssh";
      };
      settings = {
        user.name = "Emelie Graven";
        user.email = "emelie@graven.se";
        init.defaultBranch = "main";
        core.editor = "hx";
        push.autoSetupRemote = true;
        gpg.ssh.allowedSignersFile = "/home/emelie/.ssh/allowed_signers";
      };
    };
  };
}
