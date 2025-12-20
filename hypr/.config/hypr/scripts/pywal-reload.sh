#!/usr/bin/env bash

# pywal-reload.sh
# This script applies the generated Pywal colors to various applications.

# Source the pywal cache
if [ -f "$HOME/.cache/wal/colors.sh" ]; then
    . "$HOME/.cache/wal/colors.sh"
else
    echo "Pywal colors not found. Please run 'wal -i <image>' first." >&2
    exit 1
fi

# Pywalfox
# Requires 'pywalfox update' to be installed and in your PATH
# This updates browser themes. Remove if not using pywalfox.
pywalfox update &>/dev/null

# Wal_tpl for GTK/Qt/Other templates
# Requires 'wal_tpl' to be installed (e.g., pip install wal_tpl)
# Check Narsell's specific wal_tpl setup if you use this.
# wal_tpl &>/dev/null # Uncomment if you use wal_tpl

# Dunst
# Reload Dunst to apply new colors
# pkill dunst && dunst & disown

# Swaync
# Reload Swaync to apply new colors
killall -SIGUSR2 swaync

if pgrep -x "waybar" > /dev/null; then
    killall -SIGUSR2 waybar # Reload existing Waybar
else
    waybar & disown # Start Waybar if it's not running
fi

# Kitty
# Send IPC command to Kitty to reload colors
kitty @ set-colors -a ~/.cache/wal/colors-kitty.conf

# Hyprland Border Colors
# Apply active and inactive border colors from pywal
# hyprctl keyword general:col.active_border "rgb($color1)"
# hyprctl keyword general:col.inactive_border "rgb($color0)"
hyprctl keyword decoration:active_opacity 1.0
hyprctl keyword decoration:inactive_opacity 0.9

# You might have other Hyprland elements to update here
# e.g., if you use Pyprland, specific window rules, etc.
# Narsell has a specific pyprland setup.

# Generate Hyprlock colors file
~/.config/hypr/scripts/hyprlock-pywal-colors.sh

# Zathura
# Notifies Zathura to reload its config/colors
# (Requires Zathura to be running)
# pkill -USR1 zathura

# EWW (if you use it)
# Narsell uses EWW widgets, which would also be themed by Pywal.
# This might involve restarting or refreshing EWW daemons/widgets.
# If you don't use EWW, you can ignore/remove this.
# eww reload &>/dev/null # Example

# VSCode (if you use thewal theme)
# This usually involves reloading VSCode or restarting it.
# Check Narsell's specific VSCode setup.
# code --reload-windows &>/dev/null # Example

echo "Pywal theme applied to applications."
exit 0
