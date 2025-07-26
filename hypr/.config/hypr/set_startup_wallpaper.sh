#!/usr/bin/env bash

# This script is executed by Hyprland on startup to set the last wallpaper
# and re-apply Pywal colors.


#LOG_FILE="$HOME/hyprland_startup.log"
#$exec > >(tee -a "$LOG_FILE") 2>&1

#echo "[$(date)] --- set_startup_wallpaper.sh started ---"
#echo "PATH during execution: $PATH"

# Give Hyprland and its services a moment to fully initialize
sleep 0.3

LAST_WALLPAPER_FILE="$HOME/.config/hypr/last_wallpaper.txt"
MONITOR_NAME="eDP-1" # Replace with your monitor name if specific (e.g., "DP-1"), otherwise leave empty for all


# Check if the last wallpaper file exists
if [ -f "$LAST_WALLPAPER_FILE" ]; then
    LAST_WALLPAPER=$(cat "$LAST_WALLPAPER_FILE")

    # Check if the wallpaper file actually exists
    if [ -f "$LAST_WALLPAPER" ]; then
        echo "Setting startup wallpaper: $LAST_WALLPAPER"
        hyprctl hyprpaper reload "${MONITOR_NAME},${LAST_WALLPAPER}"

        # Re-run Pywal from the last wallpaper to ensure all themes are consistent
        echo "Running Pywal for startup consistency..."
        wal -i "$LAST_WALLPAPER" -n # Use -n as terminal will be configured by kitty @ later

        # --- Update Kitty theme ---
        # It's good practice to re-apply this on startup for consistency
        kitty @ set-colors -a ~/.cache/wal/colors-kitty.conf

        # --- Update Hyprland border colors ---
        ~/.config/scripts/hypr_colors.sh
    else
        echo "Last wallpaper file '$LAST_WALLPAPER' not found. Skipping."
    fi
else
    echo "No last wallpaper file found at '$LAST_WALLPAPER_FILE'. Skipping startup wallpaper."
fi

echo "[$(date)] --- set_startup_wallpaper.sh finished ---"

# For Oh My Posh, the shell's ~/.zshrc etc. will handle its own initialization
# by reading the terminal colors (which wal -i updates).
# So, a specific reload for OMP here might not be strictly necessary if your shell config sources it correctly.
