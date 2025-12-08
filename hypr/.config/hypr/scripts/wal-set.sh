#!/usr/bin/env bash

# wal-set: Rofi interface for selecting wallpapers and triggering theme changes.
# This script is designed to be called via Rofi.

# Ensure WALLPAPER_DIR has a trailing slash for consistent path handling
WALLPAPER_DIR="$HOME/.local/share/wallpapers/"

WALLPAPERS_SCRIPT="$HOME/.config/hypr/scripts/wallpapers.sh"

# Ensure wallpaper script exists
if [ ! -f "$WALLPAPERS_SCRIPT" ]; then
    echo "Error: wallpapers.sh script not found at '$WALLPAPERS_SCRIPT'" >&2
    exit 1
fi

# Function to get a list of wallpaper filenames for Rofi
get_wallpaper_filenames() {
    # This finds all image files and strips the full path, leaving only the filename.
    # The `sort -V` option sorts them numerically for better organization (e.g., 1.jpg, 2.jpg)
    # The `sed` command removes the full WALLPAPER_DIR path from the beginning of each line.
    find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) \
        | sort -V \
        | sed "s|^$WALLPAPER_DIR||"
}

# Rofi options
# We use printf to create a list with "special" options followed by the file list.
rofi_options=("Random" "Next" "Previous" "$(get_wallpaper_filenames)")

# Use Rofi to present options
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
        # Sanitize and reconstruct the full path.
        # We ensure the path is clean by removing any leading or trailing slashes
        # before joining them.
        WALLPAPER_DIR_CLEAN=$(echo "$WALLPAPER_DIR" | sed 's:/*$::') # Remove trailing slashes
        SELECTED_OPTION_CLEAN=$(echo "$selected_option" | sed 's:^/*::') # Remove leading slashes
        FULL_PATH="${WALLPAPER_DIR_CLEAN}/${SELECTED_OPTION_CLEAN}"

        if [ -f "$FULL_PATH" ]; then
            "$WALLPAPERS_SCRIPT" set "$FULL_PATH" &
        else
            echo "Error: Wallpaper file not found: '$FULL_PATH'" >&2
            exit 1
        fi
        ;;
esac

exit 0
