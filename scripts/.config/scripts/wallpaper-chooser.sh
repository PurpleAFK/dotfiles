!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/wall/" # Make sure this matches your set-wall.sh
SET_WALL_SCRIPT="$HOME/.config/scripts/set-wall.sh"

# Check if the wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Wallpaper directory not found at '$WALLPAPER_DIR'"
    exit 1
fi

# Use find to get full paths.
# Then, pipe to sed to remove the WALLPAPER_DIR prefix (including the trailing slash).
# The '^' anchors the match to the beginning of the line.
# The '|' is used as a delimiter for sed's 's' command to avoid issues with slashes in paths.
selected_filename=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) \
    | sort -V \
    | sed "s|^$WALLPAPER_DIR||" \
    | rofi -dmenu -i -p "Select Wallpaper:")

# Check if a wallpaper was selected (Rofi returns empty string if cancelled)
if [ -n "$selected_filename" ]; then
    # Reconstruct the full path to the selected wallpaper.
    # Since WALLPAPER_DIR already ends with '/', no need for an extra '/'.
    full_wallpaper_path="${WALLPAPER_DIR}${selected_filename}"

    # Call your set-wall.sh script with the full path
    "$SET_WALL_SCRIPT" "$full_wallpaper_path" & # Run in the background
else
    echo "No wallpaper selected."
fi
