#!/usr/bin/env bash

# Use different directory on NixOS
if [ -d /run/current-system/sw/libexec ]; then
    libDir=/run/current-system/sw/libexec
else
    echo "Error: /run/current-system/sw/libexec not found. Is this NixOS?"
    exit 1
fi

${libDir}/polkit-gnome/polkit-gnome-authentication-agent-1 &
