#!/bin/sh

# Get the current default sink
SINK=$(pactl get-default-sink)

case "$1" in
    --inc)
        pactl set-sink-volume "$SINK" +5%
        ;;
    --dec)
        pactl set-sink-volume "$SINK" -5%
        ;;
esac
