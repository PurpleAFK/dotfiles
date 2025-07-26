#!/usr/bin/env bash

# This script sets a wallpaper with Hyprpaper and updates Kitty's theme with Pywal.
# Usage: ./set_wallpaper_and_theme.sh /path/to/your/image.jpg

# Check if an image path argument is provided
if [ -z "$1" ]; then
    echo "Error: No image path provided."
    echo "Usage: $0 /path/to/your/image.jpg"
    exit 1
fi

IMAGE_PATH="$1"

# --- Configuration ---
WALLPAPER_DIR="$HOME/Pictures/Wallpapers" # Customize this to your wallpaper directory
LAST_WALLPAPER_FILE="$HOME/.config/hypr/last_wallpaper.txt" # File to store the path of the last wallpaper


# Check if the provided image path exists
if [ ! -f "$IMAGE_PATH" ]; then
    echo "Error: Image file not found at '$IMAGE_PATH'"
    exit 1
fi

# --- Hyprpaper Configuration ---
# You can get your monitor name by running 'hyprctl monitors' in a terminal.
# If you have multiple monitors and want to set the wallpaper on a specific one,
# replace 'monitor_name' with your actual monitor's identifier (e.g., 'DP-1', 'HDMI-A-1', 'eDP-1').
# If you want to set it on all monitors, leave it empty (i.e., MONITOR_NAME="").
MONITOR_NAME="eDP-1" # Example: MONITOR_NAME="DP-1"

# --- Set Wallpaper with Hyprpaper ---
echo "Setting wallpaper to: $IMAGE_PATH"
# Using 'reload' is simpler as it handles preloading and setting in one go.
# The ',' before "$IMAGE_PATH" means apply to all configured monitors if MONITOR_NAME is empty.
hyprctl hyprpaper reload "${MONITOR_NAME},${IMAGE_PATH}"

# Check if hyprctl command was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to set wallpaper with hyprctl. Is hyprpaper running?"
    exit 1
fi

# --- Save the path of the newly set wallpaper ---
echo "$IMAGE_PATH" > "$LAST_WALLPAPER_FILE"
echo "Saved last wallpaper path to: $LAST_WALLPAPER_FILE"

# --- Pywal and Kitty Theme Configuration ---
# Pywal generates color schemes. The '-n' flag prevents Pywal from applying
# colors directly via ANSI escape sequences to the current terminal,
# as we'll use Kitty's IPC for a cleaner update.
echo "Generating color scheme with Pywal from: $IMAGE_PATH"
wal -i "$IMAGE_PATH" -n

# Check if wal command was successful
if [ $? -ne 0 ]; then
    echo "Error: Pywal failed to generate colors. Is Pywal installed?"
    exit 1
fi

# Tell Kitty to reload its colors from the generated config file
# This command forces all running Kitty instances to update their colors.
KITTY_CONFIG_PATH="$HOME/.cache/wal/colors-kitty.conf"
echo "Updating Kitty theme from: $KITTY_CONFIG_PATH"
kitty @ set-colors -a "$KITTY_CONFIG_PATH"

# Check if kitty @ command was successful
if [ $? -ne 0 ]; then
    echo "Warning: Failed to update Kitty theme. Is Kitty running and reachable via IPC?"
    echo "Make sure you have 'include ~/.cache/wal/colors-kitty.conf' in your ~/.config/kitty/kitty.conf"
fi

echo "Updating Hyprland border colors..."
 ~/.config/scripts/hypr_colors.sh

# --- Waybar Reload/Restart ---
echo "Reloading/Restarting Waybar to apply new colors..."

# Check if Waybar is running
if pgrep -x "waybar" > /dev/null; then
    # If Waybar is running, attempt to gracefully reload its style
    # This assumes 'reload_style_on_change' is true in Waybar config
    # If it's not working consistently, you might need to restart it fully.
    killall -SIGUSR2 waybar
    echo "Sent SIGUSR2 to Waybar (attempting reload)."
    sleep 1 # Give Waybar a moment to process the signal
else
    echo "Waybar is not running. Starting Waybar..."
    # If Waybar is not running, start it
    # You might need to adjust this command if your Waybar launch command is different
    # For example, if you run it from a script or with specific arguments.
    waybar & disown
    echo "Started Waybar."
fi

echo "Wallpaper, Kitty, Oh My Posh, Waybar and Hyprland borders updated successfully!"
exit 0
