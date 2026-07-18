#!/bin/bash

LOCK_FILE="/tmp/caffeine_active"

if [ -f "$LOCK_FILE" ]; then
    echo '{"text": "active", "tooltip": "Sleep mode disabled", "alt": "active", "class": "active"}'
else
    echo '{"text": "inactive", "tooltip": "Sleep mode enabled", "alt": "inactive", "class": "inactive"}'
fi