#!/usr/bin/env bash

# wallpapers.sh
# Sets wallpaper with swww, generates Pywal colors, and reloads applications.

WALLPAPER_DIR="$HOME/.local/share/wallpapers/"
LAST_WALLPAPER_FILE="$HOME/.config/hypr/last_wallpaper.txt"
PYWAL_RELOAD_SCRIPT="$HOME/.config/hypr/scripts/pywal-reload.sh"

# Get a list of all image files in the wallpaper directory
get_wallpaper_list_full_paths() {
    find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | sort -V
}

# Usage: wallpapers.sh <action> [wallpaper_path]
# Actions: set <path>, random, next, prev, startup

case "$1" in
    set)
        IMAGE_PATH="$2"
        if [ -z "$IMAGE_PATH" ] || [ ! -f "$IMAGE_PATH" ]; then
            echo "Error: Invalid or no wallpaper path provided for 'set'." >&2
            exit 1
        fi
        ;;
    random)
        IMAGE_PATH=$(get_wallpaper_list_full_paths | shuf -n 1)
        ;;
    next|prev)
        CURRENT_WALLPAPER=$(cat "$LAST_WALLPAPER_FILE" 2>/dev/null)
        WALLPAPERS=($(get_wallpaper_list_full_paths))
        NUM_WALLPAPERS=${#WALLPAPERS[@]}

        if [ "$NUM_WALLPAPERS" -eq 0 ]; then
            echo "No wallpapers found in $WALLPAPER_DIR." >&2
            exit 1
        fi

        CURRENT_INDEX=-1
        for i in "${!WALLPAPERS[@]}"; do
            if [[ "${WALLPAPERS[$i]}" == "$CURRENT_WALLPAPER" ]]; then
                CURRENT_INDEX=$i
                break
            fi
        done

        if [ "$1" = "next" ]; then
            NEXT_INDEX=$(((CURRENT_INDEX + 1) % NUM_WALLPAPERS))
        else # prev
            NEXT_INDEX=$(((CURRENT_INDEX - 1 + NUM_WALLPAPERS) % NUM_WALLPAPERS))
        fi
        IMAGE_PATH="${WALLPAPERS[$NEXT_INDEX]}"
        ;;
    startup)
        # On startup, set the last wallpaper or a random one if no last one
        if [ -f "$LAST_WALLPAPER_FILE" ]; then
            LAST_PATH=$(cat "$LAST_WALLPAPER_FILE")
            if [ -f "$LAST_PATH" ]; then
                IMAGE_PATH="$LAST_PATH"
            else
                echo "Last wallpaper not found. Picking a random one for startup."
                IMAGE_PATH=$(get_random_wallpaper)
            fi
        else
            echo "No last wallpaper file found. Picking a random one for startup."
            IMAGE_PATH=$(get_random_wallpaper)
        fi
        ;;
    *)
        echo "Usage: $0 {set <path> | random | next | prev | startup}" >&2
        exit 1
        ;;
esac

if [ -z "$IMAGE_PATH" ] || [ ! -f "$IMAGE_PATH" ]; then
    echo "Error: No valid wallpaper selected or found: '$IMAGE_PATH'" >&2
    exit 1
fi

echo "Setting wallpaper via swww to: $IMAGE_PATH"

# Use swww for setting wallpaper
# You might want to adjust the transition type and duration
swww img "$IMAGE_PATH" \
    --transition-type grow \
    --transition-pos "top-right" \
    --transition-duration 0.8

if [ $? -ne 0 ]; then
    echo "Error: Failed to set wallpaper with swww. Is swww running?" >&2
    echo "Make sure 'swww init' is run on Hyprland startup." >&2
    exit 1
fi

echo "$IMAGE_PATH" > "$LAST_WALLPAPER_FILE"
echo "Saved last wallpaper path to: $LAST_WALLPAPER_FILE"

echo "Generating Pywal colors from: $IMAGE_PATH"
wal -i "$IMAGE_PATH" -n # Generate colors without applying to current terminal

if [ $? -ne 0 ]; then
    echo "Error: Pywal failed to generate colors." >&2
    exit 1
fi

# Apply the generated Pywal theme to applications
echo "Applying theme to applications via $PYWAL_RELOAD_SCRIPT"
"$PYWAL_RELOAD_SCRIPT" & # Run in background to not block wallpaper setter

echo "Wallpaper set and theme update initiated."
exit 0
