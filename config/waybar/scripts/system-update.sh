#!/usr/bin/env bash

# Check for updates on NixOS
# This is a rough estimation based on comparing the current system flake input revision with the remote.
# Real "available updates" detection on NixOS is complex. 
# This script simply acts as a placeholder or a simple "rebuild" trigger.

ICON_UPDATE=$(printf '\U000F0E1F')   # 󰸟
ICON_DOWNLOAD=$(printf '\uF409')     # 

if [ "$1" == "up" ]; then
    command="
    echo 'Starting NixOS Rebuild...'
    cd ~/Hyprladus && nixos-rebuild switch --flake .#default
    printf '\n'
    read -n 1 -p 'Press any key to continue...'
    "
    kitty --title "$ICON_DOWNLOAD  System Update" sh -c "${command}"
    exit 0
fi

# return empty json to hide the module by default, preventing errors
exit 0
