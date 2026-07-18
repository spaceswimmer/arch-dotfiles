#!/bin/bash

notify() {
    notify-send "WiFi" "$1"
}

case "$1" in
    toggle)
        if nmcli radio wifi | grep -q enabled; then
            nmcli radio wifi off
            notify "WiFi turned off"
        else
            nmcli radio wifi on
            notify "WiFi turned on"
        fi
        exit 0
        ;;
esac

nmcli radio wifi on

CURRENT_SSID=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)

nmcli device wifi rescan 2>/dev/null

SCAN_RESULT=$(nmcli -t -f SSID,SECURITY,SIGNAL device wifi list 2>/dev/null)

SSID_LIST=$(echo "$SCAN_RESULT" | while IFS=: read -r ssid sec sig; do
    [ -z "$ssid" ] && continue
    [ "$ssid" = "--" ] && continue

    if [ -z "$sec" ]; then
        lock=""
    else
        lock=""
    fi

    if [ "${sig:-0}" -ge 80 ]; then
        bars=""
    elif [ "${sig:-0}" -ge 60 ]; then
        bars=""
    elif [ "${sig:-0}" -ge 40 ]; then
        bars=""
    elif [ "${sig:-0}" -ge 20 ]; then
        bars=""
    else
        bars=""
    fi

    printf "%s %s %s\n" "$lock" "$bars" "$ssid"
done | sort -k3 -u | sort -k2 -r)

if [ -z "$SSID_LIST" ]; then
    notify "No networks found"
    exit 1
fi

SELECTED=$(echo "$SSID_LIST" | rofi -dmenu -p " WiFi" -theme ~/.config/rofi/launchers/type-1/style-1.rasi -theme-str 'listview {lines: 12; columns: 1;} inputbar {spacing: 0;}')

[ -z "$SELECTED" ] && exit 0

SELECTED_SSID=$(echo "$SELECTED" | sed 's/^[^ ]* [^ ]* //')

[ -z "$SELECTED_SSID" ] && exit 0

if nmcli -t -f ACTIVE,SSID dev wifi | grep -q "^yes:$SELECTED_SSID$"; then
    nmcli connection down "$SELECTED_SSID" 2>/dev/null || \
    nmcli device disconnect "$(nmcli -t -f DEVICE connection show --active | head -1 | cut -d: -f1)"
    notify "Disconnected from $SELECTED_SSID"
    exit 0
fi

SEC_TYPE=$(echo "$SCAN_RESULT" | grep "^$SELECTED_SSID:" | head -1 | cut -d: -f2)

if [ "$SELECTED_SSID" = "$CURRENT_SSID" ]; then
    notify "Already connected to $SELECTED_SSID"
    exit 0
fi

if nmcli -t -f NAME connection show | grep -qx "$SELECTED_SSID"; then
    if nmcli connection up "$SELECTED_SSID"; then
        notify "Connected to $SELECTED_SSID"
    else
        notify "Failed to connect to $SELECTED_SSID"
    fi
    exit 0
fi

if [ -z "$SEC_TYPE" ] || [ "$SEC_TYPE" = "--" ]; then
    if nmcli device wifi connect "$SELECTED_SSID"; then
        notify "Connected to $SELECTED_SSID"
    else
        notify "Failed to connect to $SELECTED_SSID"
    fi
else
    PASSWORD=$(rofi -dmenu -password -p "Password for $SELECTED_SSID" -theme ~/.config/rofi/launchers/type-1/style-1.rasi -theme-str 'inputbar {spacing: 0;} listview {enabled: false;}')
    [ -z "$PASSWORD" ] && exit 0
    if nmcli device wifi connect "$SELECTED_SSID" password "$PASSWORD"; then
        notify "Connected to $SELECTED_SSID"
    else
        notify "Failed to connect to $SELECTED_SSID"
    fi
fi