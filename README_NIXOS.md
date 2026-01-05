# Hyprladus for NixOS

This directory contains the configuration to port the Hyprladus setup to NixOS using Flakes and Home Manager.

## Prerequisites

1.  **Install NixOS**: Install NixOS on your machine. During installation, you can use a minimal config.
2.  **Enable Flakes**: Ensure you have flakes enabled. If not, add `experimental-features = nix-command flakes` to your `/etc/nixos/configuration.nix`.

## Installation

1.  **Clone the Repository**:
    ```bash
    git clone https://github.com/sachatrouve1/Hyprladus.git ~/Hyprladus
    cd ~/Hyprladus
    ```

2.  **Generate Hardware Configuration**:
    Copy your existing hardware configuration to the `nixos` directory.
    ```bash
    cp /etc/nixos/hardware-configuration.nix ./nixos/
    ```

3.  **Edit Configuration**:
    -   Open `nixos/configuration.nix` and `nixos/home.nix`.
    -   Change `user` to your actual username in both files.
    -   Update `networking.hostName` and `time.timeZone` in `nixos/configuration.nix` if needed.

4.  **Apply Configuration**:
    Run the following command to build and switch to the new configuration:
    ```bash
    nixos-rebuild switch --flake .#default
    ```

5.  **Reboot**:
    Reboot your system to enter the Hyprland session.
    ```bash
    reboot
    ```

## Post-Installation

-   **Wallpaper**: The wallpaper script `set_wallpaper.sh` is linked to your home directory. You can use it to set the wallpaper and generate the Pywal theme.
    ```bash
    ~/set_wallpaper.sh ~/Pictures/Wallpapers/your_wallpaper.png
    ```
-   **Waybar/Rofi**: These should work out of the box as their configs are linked.

## Notes

-   **Flake Location**: The `flake.nix` is located at the root of the repository.
-   **Config Files**: The configuration files in `config/` are symlinked by Home Manager. Any changes you make to them in `~/Hyprladus/config` will be reflected (you might need to reload Hyprland or the specific app).
-   **Updates**: To update the system, run `nix flake update` and then `nixos-rebuild switch --flake .`.
