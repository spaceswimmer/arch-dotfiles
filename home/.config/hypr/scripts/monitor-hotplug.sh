#!/bin/bash
set -euo pipefail

# Listens for monitor changes and gracefully reloads waybar

inst_sig="$HYPRLAND_INSTANCE_SIGNATURE"
socket="$XDG_RUNTIME_DIR/hypr/$inst_sig/.socket2.sock"

if [[ ! -S "$socket" ]]; then
    notify-send -u critical "monitor-hotplug" "Event socket not found: $socket"
    exit 1
fi

python3 -c "
import socket
import subprocess
import time

sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
sock.connect('$socket')

with sock.makefile('r', buffering=1) as f:
    for line in f:
        line = line.strip()
        if line.startswith('monitoradded>>') or line.startswith('monitorremoved>>'):
            time.sleep(0.5)
            subprocess.Popen(
                ['bash', '-c', 'pkill -SIGUSR2 waybar 2>/dev/null; sleep 1; pgrep -x waybar >/dev/null || waybar &>/dev/null &'],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL
            )
"
