#!/usr/bin/env bash
hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap' | grep -oP '^\S+' | head -c 2 | tr 'a-z' 'A-Z'
