PYWAL_CACHE_DIR="$HOME/.cache/wal"
COLORS_JSON="$PYWAL_CACHE_DIR/colors.json"

# --- Dependency Checks ---
if ! command -v jq &> /dev/null; then
    echo "Error: 'jq' is not installed or not in PATH. Please install jq." >&2
    exit 1
fi
if ! command -v hyprctl &> /dev/null; then
    echo "Error: 'hyprctl' is not installed or not in PATH. Please ensure Hyprland utilities are available." >&2
    exit 1
fi

# Check if colors.json exists
if [ ! -f "$COLORS_JSON" ]; then
    echo "Error: Pywal colors.json not found at '$COLORS_JSON'." >&2
    echo "Please ensure 'wal -i <image_path>' has been run successfully before calling this script." >&2
    exit 1
fi

# --- Extract colors one by one (more robust assignment) ---
# Extract active border color
active_hex=$(jq -r '.colors.color4' "$COLORS_JSON" 2>/dev/null)
if [ -z "$active_hex" ]; then
    echo "Error: Failed to extract 'color4' from colors.json. Check JSON path or file content." >&2
    echo "--- Content of $COLORS_JSON for debugging ---" >&2
    cat "$COLORS_JSON" >&2
    echo "------------------------------------------" >&2
    exit 1
fi

# Extract inactive border color
inactive_hex=$(jq -r '.special.background' "$COLORS_JSON" 2>/dev/null)
if [ -z "$inactive_hex" ]; then
    echo "Error: Failed to extract 'special.background' from colors.json. Check JSON path or file content." >&2
    echo "--- Content of $COLORS_JSON for debugging ---" >&2
    cat "$COLORS_JSON" >&2
    echo "------------------------------------------" >&2
    exit 1
fi

# Convert to RGBA format with desired alpha
# Remove the '#' prefix from hex_color and append alpha
ACTIVE_BORDER_COLOR="rgba(${active_hex#\#}ff)"       # Color4 (blue) fully opaque
INACTIVE_BORDER_COLOR="rgba(${inactive_hex#\#}aa)" # Background with 66% opacity

echo "Applying new border colors dynamically:"
echo "Active Border: $ACTIVE_BORDER_COLOR"
echo "Inactive Border: $INACTIVE_BORDER_COLOR"

# --- Apply colors dynamically using hyprctl keyword ---
# Set the active border color
hyprctl keyword general:col.active_border "$ACTIVE_BORDER_COLOR"
if [ $? -ne 0 ]; then
    echo "Warning: Failed to set active border color with hyprctl." >&2
fi

# Set the inactive border color
hyprctl keyword general:col.inactive_border "$INACTIVE_BORDER_COLOR"
if [ $? -ne 0 ]; then
    echo "Warning: Failed to set inactive border color with hyprctl." >&2
fi

echo "Hyprland border colors updated successfully (dynamically)."
