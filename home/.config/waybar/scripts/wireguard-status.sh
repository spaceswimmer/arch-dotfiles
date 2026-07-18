#!/bin/bash
OUTPUT=$(~/.config/waybar/wireguard-rofi-waybar/wireguard.sh 2>/dev/null)
if [ -n "$OUTPUT" ]; then
    TOOLTIP=$(echo "$OUTPUT" | grep -o '"tooltip": *"[^"]*"' | cut -d'"' -f4)
    echo "{\"text\": \"󰖆\", \"tooltip\": \"$TOOLTIP\", \"alt\": \"connected\", \"class\": \"connected\"}"
else
    echo '{"text": "󰖂", "tooltip": "WireGuard: Disconnected", "alt": "disconnected", "class": "disconnected"}'
fi
