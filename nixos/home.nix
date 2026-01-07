{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "root";
  home.homeDirectory = "/root";

  home.sessionPath = [
    "$HOME/.local/share/bin"
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Hyprland & Wayland utils
    hyprpicker
    waybar
    hyprlock
    hypridle
    hyprcursor
    rofi
    swww
    swaynotificationcenter
    nwg-look
    nwg-displays
    grim
    slurp
    wl-clipboard
    pamixer
    
    # Applications
    firefox
    kitty
    xfce.thunar
    discord
    micro
    neovim
    pkgs.feh
    pkgs.kdePackages.okular
    pkgs.pavucontrol
    
    # CLI Tools
    bat
    btop
    fastfetch
    eza
    tree
    zoxide
    fzf
    jq
    brightnessctl
    ripgrep
    
    # Theming
    pywal
    adwaita-icon-theme
    papirus-icon-theme
    
    # Audio
    cava
    
    # Scripts dependencies
    libnotify
    imagemagick
    polkit_gnome
    pkgs.qt6Packages.qt6ct
    libsForQt5.qt5ct
    spicetify-cli
    xdotool
    cliphist
    tesseract
    swappy
    wlogout
    playerctl
    swayosd
    pywalfox-native
    parallel
    psmisc # killall
    procps # pkill, pgrep
  ];

  services.udiskie.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # Link configuration files
    # Assuming the repo is cloned at ~/Hyprladus
    
    ".config/hypr".source = ../config/hypr;
    ".config/waybar".source = ../config/waybar;
    ".config/rofi".source = ../config/rofi;
    ".config/kitty".source = ../config/kitty;
    ".config/cava".source = ../config/cava;
    ".config/fastfetch".source = ../config/fastfetch;
    ".config/wlogout".source = ../config/wlogout;
    # ".config/swaync".source = ../config/swaync; # Missing in repo
    ".config/wal".source = ../config/wal;
    ".config/spicetify".source = ../config/spicetify;
    ".config/Thunar".source = ../config/Thunar;
    ".config/gtk-3.0".source = ../config/gtk-3.0;
    ".config/gtk-4.0".source = ../config/gtk-4.0;

    # Scripts
    ".local/share/bin" = {
      source = ../local_share;
    };
    
    # Wallpapers
    "Pictures/Wallpapers".source = ../Wallpapers;
    
    # Root scripts
    #"set_wallpaper.sh".source = ../set_wallpaper.sh; # Moved to local_share
    #"rmnot.sh".source = ../rmnot.sh; # Deleted
    
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  # Programs configuration
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your.email@example.com";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    # Oh-my-zsh
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "history" "z" ];
      theme = "robbyrussell"; # We will override this with p10k
    };

    initExtra = ''
      # Source Powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      
      # Add local bin to path
      export PATH=$HOME/.local/share/bin:$PATH
      
      # Pywal
      (cat ~/.cache/wal/sequences &)
      
      # Aliases
      alias ls='eza --icons'
      alias ll='eza -al --icons'
      alias setwallpaper='set_wallpaper.sh'
    '';
  };
  
  # Link .p10k.zsh
  home.file.".p10k.zsh".source = ../.p10k.zsh;

  # Link scripts to ~/.local/share/bin 
  # (Must be referenced as absolute path or relative to flake root if using flake-utils/extra-files, but home-manager source is relative to this file)

  # GTK Theme
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Original-Classic";
      package = pkgs.bibata-cursors;
    };
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
