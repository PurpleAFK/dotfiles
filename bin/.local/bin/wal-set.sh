#!/usr/bin/env bash

# wal-set: Rofi interface for selecting wallpapers and triggering theme changes.
# This script is designed to be called via Rofi.

WALLPAPER_DIR="$HOME/.local/share/wallpapers"
WALLPAPERS_SCRIPT="$HOME/.config/hypr/scripts/wallpapers.sh"

# Ensure wallpaper script exists
if [ ! -f "$WALLPAPERS_SCRIPT" ]; then
    echo "Error: wallpapers.sh script not found at '$WALLPAPERS_SCRIPT'" >&2
    exit 1
fi

# Function to get a list of wallpaper filenames for Rofi
get_wallpaper_filenames() {
    find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) \
        | sort -V \
        | sed "s|^$WALLPAPER_DIR/||" # Strips the full path, leaving only the filename
}

# Rofi options
rofi_options=("Random" "Next" "Previous" "$(get_wallpaper_filenames)")

# Use Rofi to present options
# Narsell typically uses custom Rofi themes, ensure your Rofi config points to them
# -theme-str can be used for quick inline theming if you don't use external .rasi files
selected_option=$(printf "%s\n" "${rofi_options[@]}" | rofi -dmenu -i -p "Wallpaper:")

# Process selection
case "$selected_option" in
    "Random")
        "$WALLPAPERS_SCRIPT" random &
        ;;
    "Next")
        "$WALLPAPERS_SCRIPT" next &
        ;;
    "Previous")
        "$WALLPAPERS_SCRIPT" prev &
        ;;
    "") # User cancelled Rofi
        echo "No wallpaper selected. Exiting."
        exit 0
        ;;
    *) # A specific wallpaper file was selected
        # Reconstruct full path
        FULL_PATH="${WALLPAPER_DIR}/${selected_option}"
        if [ -f "$FULL_PATH" ]; then
            "$WALLPAPERS_SCRIPT" set "$FULL_PATH" &
        else
            echo "Error: Wallpaper file not found: '$FULL_PATH'" >&2
            exit 1
        fi
        ;;
esac

exit 0
