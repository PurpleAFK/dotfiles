#!/usr/bin/env bash
set -euo pipefail

# 1. Ensure Anki + AnkiConnect are up
if ! curl -sf -X POST -d '{"action":"version","version":6}' http://127.0.0.1:8765 >/dev/null 2>&1; then
  notify-send "anki-sync" "Anki not running — launching"
  anki >/dev/null 2>&1 &
  for i in {1..10}; do
    sleep 1
    curl -sf -X POST -d '{"action":"version","version":6}' http://127.0.0.1:8765 >/dev/null 2>&1 && break
  done
fi

# 2. Ensure Obsidian is up
if ! pgrep -f 'obsidian' >/dev/null; then
  notify-send "anki-sync" "Obsidian not running — launching"
  obsidian >/dev/null 2>&1 &
  sleep 3
fi

# 3. Focus Obsidian, send hotkey (Ctrl+Shift+A is our bound Scan Vault)
hyprctl dispatch focuswindow "class:obsidian" >/dev/null 2>&1 \
  || hyprctl dispatch focuswindow "class:Obsidian" >/dev/null 2>&1
sleep 0.25
wtype -M ctrl -M shift a
sleep 0.15
wtype -m ctrl -m shift

notify-send "anki-sync" "Scan triggered"
