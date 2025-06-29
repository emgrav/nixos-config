{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [

  # Security and authentication
  yubikey-agent

  # App and package management
  gnumake
  cmake
  home-manager

  # Media and design tools
  vlc
  fontconfig
  font-manager

  # Audio tools
  pavucontrol # Pulse audio controls

  # Testing and development tools
  direnv
  rofi
  rofi-calc
  libtool # for Emacs vterm

  # Text and terminal utilities
  feh # Manage wallpapers
  screenkey
  tree
  unixtools.ifconfig
  unixtools.netstat

  # File and system utilities
  inotify-tools # inotifywait, inotifywatch - For file system events
  libnotify
  pcmanfm # File browser
  xdg-utils

  # Other utilities
  yad # yad-calendar is used with polybar
  xdotool

  # PDF viewer
  zathura

  # Music and entertainment
  spotify
]
