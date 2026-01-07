#!/usr/bin/env bash
sleep 1
killall -e xdg-desktop-portal-hyprland
killall xdg-desktop-portal
if [ -d /run/current-system/sw/libexec ]; then
    LIBEXEC="/run/current-system/sw/libexec"
else
    echo "Error: /run/current-system/sw/libexec not found. Is this NixOS?"
    exit 1
fi

$LIBEXEC/xdg-desktop-portal-hyprland &
sleep 2
$LIBEXEC/xdg-desktop-portal &
