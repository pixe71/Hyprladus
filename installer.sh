#!/usr/bin/env bash

set -e # exit on any error

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
    echo "${ERROR}  This script should ${WARNING}NOT${RESET} be executed as root!! Exiting......." | tee -a "$LOG"
    printf "\n%.0s" {1..2}
    exit 1
fi

LOG="./install.log"
exec > >(tee -a "$LOG") 2>&1

clear

echo "  _    _                  _           _           "
echo " | |  | |                | |         | |          "
echo " | |__| |_   _ _ __  _ __| | __ _  __| |_   _ ___ "
echo " |  __  | | | | '_ \\| '__| |/ _\` |/ _\` | | | / __|"
echo " | |  | | |_| | |_) | |  | | (_| | (_| | |_| \\__ \\"
echo " |_|  |_|\\__, | .__/|_|  |_|\\__,_|\\__,_|\\__,_|___/"
echo "          __/ | |                                 "
echo "         |___/|_|                                 "

sudo pacman -S --needed --noconfirm git base-devel

tmp_dir=$(mktemp -d)

# YAY INSTALLATION
if ! command -v yay &>/dev/null; then
    echo "Installing yay..."
    git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay"

    cd "$tmp_dir/yay" || exit
    makepkg -si --noconfirm

    cd ~ || exit
    rm -rf "$tmp_dir"
else
    echo "yay already installed."
fi

pacman_packages=(
    hyprland
    networkmanager
    network-manager-applet
    hyprpicker
    firefox
    waybar
    micro
    vim
    neovim
    kitty
    hyprpolkitagent
    hyprlock
    hypridle
    hyprsunset
    hyprland-qt-support
    hyprqt6engine
    hyprcursor
    hyprutils
    hyprlang
    aquamarine
    hyprgraphics
    hyprland-qtutils
    xdg-desktop-portal-hyprland
    rofi
    thunar
    bat
    btop
    neofetch
    fastfetch
    grim
    slurp
    wl-clipboard
    swww
    swaync
    polkit
    pamixer
    caffeine
    nwg-look
    nwg-displays
    tree
    eza
    zsh
    zsh-completions
    pipewire
    wireplumber
    qt5-wayland
    qt6-wayland
    ttf-jetbrains-mono-nerd
    ttf-nerd-fonts-symbols
    ttf-nerd-fonts-symbols-mono
    ttf-dejavu
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    adwaita-icon-theme
    papirus-icon-theme
    udiskie
    discord
    cava
    blueman
    feh
    okular
    timeshift
    greetd
    greetd-tuigreet
    zoxide
    fzf
    pacman-contrib
    gtk-engine-murrine
    pavucontrol
    brightnessctl
    jq
    cliphist
)

# AUR packages (install with yay)
aur_packages=(
    auto-cpufreq
    python-pywal16
    python-pywalfox
    pywal-spicetify
    spicetify-cli
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-history-substring-search
    zsh-you-should-use
    gtk-theme-material-black
)

echo "----------------------------------------"
echo " Installing official packages (pacman)..."
echo "----------------------------------------"

sudo pacman -Syu --needed --noconfirm "${pacman_packages[@]}" || {
    echo "⚠️  Some pacman packages failed to install."
}

echo "----------------------------------------"
echo " Verifying missing packages..."
echo "----------------------------------------"

missing_pkgs=()

for pkg in "${pacman_packages[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
        missing_pkgs+=("$pkg")
    fi
done

if ((${#missing_pkgs[@]} > 0)); then
    echo "⚠️  Some official packages were not found in pacman, retrying via yay:"
    printf ' - %s\n' "${missing_pkgs[@]}"
    yay -S --noconfirm --needed "${missing_pkgs[@]}" || echo "⚠️  Could not install some fallback packages."
else
    echo "✅  All pacman packages installed successfully."
fi

echo "----------------------------------------"
echo " Installing AUR packages (yay)..."
echo "----------------------------------------"

for pkg in "${aur_packages[@]}"; do
    if ! yay -Qi "$pkg" &>/dev/null; then
        echo "Installing $pkg (AUR)..."
        yay -S --noconfirm --needed "$pkg" || echo "⚠️  Cannot install $pkg"
    else
        echo "$pkg already installed."
    fi
done

echo "----------------------------------------"
echo "✅ Package installation complete."
echo "Log saved at: $LOG"
echo "----------------------------------------"


echo "Enabling services"
sudo systemctl enable NetworkManager.service
sudo systemctl enable greetd.service
sudo systemctl enable auto-cpufreq.service
sudo systemctl enable bluetooth.service


# COPYING FILES

mkdir -p ~/.local/share/bin ~/.cache/wal ~/.config/wal ~/Pictures ~/.config ~/etc/greetd ~/Documents ~/Downloads ~/Music ~/Videos

echo "Copying .oh-my-zsh"
cp -r .oh-my-zsh ~/
echo "Copying .bashrc"
cp .bashrc ~/
echo "Copying .zshrc"
cp .zshrc ~/
echo "Copying .p10k.zsh"
cp .p10k.zsh ~/
echo "Copying set_wallpaper.sh"
cp set_wallpaper.sh ~/
echo "Copying rmnot.sh"
cp rmnot.sh ~/
echo "Copying wallpapers"
cp -r Wallpapers/ ~/Pictures/
echo "Copying kitty config"
cp -r config/kitty ~/.config/
echo "Copying wal cache"
cp -r cache/wal ~/.cache/
echo "Copying wal config"
cp -r config/wal ~/.config/
echo "Copying scripts"
cp -r local_share/* ~/.local/share/bin/
echo "Copying cava config"
cp -r config/cava ~/.config/
echo "Copying fastfetch config"
cp -r config/fastfetch ~/.config/
echo "Copying hypr config"
cp -r config/hypr ~/.config/
echo "Copying rofi config"
cp -r config/rofi ~/.config/
echo "Copying waybar config"
cp -r config/waybar/ ~/.config/
echo "Copying cursor theme"
sudo cp -r Bibata-Original-Classic /usr/share/icons/
echo "Copying greetui config"
sudo cp greetui/config.toml /etc/greetd/
echo "Copying zsh dependencies"
sudo cp -r zsh /usr/share/
sudo cp -r zsh-theme-powerlevel10k /usr/share/
echo "Copying Spicetify config"
cp -r config/spicetify ~/.config/

sudo chsh -s /usr/bin/zsh root
sudo chsh -s /usr/bin/zsh "$USER"

./set_wallpaper.sh Wallpapers/hypr.png

echo "Hyprladus installation finished!"

read -rp "Do you want to reboot? (Y/n): " answer
if [[ "$answer" == "n" || "$answer" == "N" ]]; then
    echo "Reboot cancelled."
else
    reboot
fi

