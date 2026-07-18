#!/bin/bash

# Get all sink names in order
mapfile -t SINKS < <(/usr/sbin/pactl list short sinks | awk '{print $2}')
CURRENT=$(/usr/sbin/pactl get-default-sink)

# Find index of current sink
IDX=-1
for i in "${!SINKS[@]}"; do
  if [ "${SINKS[$i]}" = "$CURRENT" ]; then
    IDX=$i
    break
  fi
done

# Pick next sink (wrap around)
NEXT=$(( (IDX + 1) % ${#SINKS[@]} ))
TARGET="${SINKS[$NEXT]}"

# Get description for notification
DESC=$(/usr/sbin/pactl list sinks | awk -v n="$TARGET" '
  /Sink #/ {found=0}
  $0 ~ "Name: "n {found=1}
  found && /Description:/ {gsub(/^[[:space:]]*Description:[[:space:]]*/,""); print; exit}
')

/usr/sbin/pactl set-default-sink "$TARGET"
/usr/sbin/pactl list short sink-inputs | while read -r id rest; do
  /usr/sbin/pactl move-sink-input "$id" "$TARGET" 2>/dev/null || true
done

notify-send "Audio output" "${DESC:-$TARGET}" -t 1500
