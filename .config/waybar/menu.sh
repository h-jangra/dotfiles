#!/bin/bash

# Power menu options
OPTIONS="Shutdown\nReboot\nLock\nSuspend\nLogout"

# Show menu using rofi
CHOICE=$(echo -e $OPTIONS | rofi -dmenu -p "Power Menu")

# Execute action
case "$CHOICE" in
    Shutdown)
        systemctl poweroff
        ;;
    Reboot)
        systemctl reboot
        ;;
    Lock)
        hyprlock
        ;;
    Suspend)
        systemctl suspend
        ;;
    Logout)
        # Detect session type
        if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
            # For sway/hyprland
            if command -v swaymsg &>/dev/null; then
                swaymsg exit
            elif command -v hyprctl &>/dev/null; then
                hyprctl dispatch exit
            else
                notify-send "Logout: Unsupported compositor"
            fi
        else
            # Fallback for X11
            pkill -KILL -u $USER
        fi
        ;;
esac
