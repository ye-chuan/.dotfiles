#!/bin/bash

# Power Menu implemented via Fuzzel

ANCHOR="top-right"
X_MARGIN="9"
Y_MARGIN="7"

SELECTION="$(printf "󰌾 Lock\n󰤄 Suspend\n󰍃 Log out\n Reboot\n Reboot to UEFI\n󰐥 Shutdown" |
    fuzzel --dmenu -a "$ANCHOR" --x-margin="$X_MARGIN" --y-margin="$Y_MARGIN" -l 6 -w 18 -p "Select an option: ")"

confirm_action() {
    local action="$1"
    CONFIRMATION="$(printf "No\nYes" |
        fuzzel --dmenu -a "$ANCHOR" --x-margin="$X_MARGIN" --y-margin="$Y_MARGIN" -l 2 -w 18 -p "$action? ")"
    [[ "$CONFIRMATION" == *"Yes"* ]]
}

case $SELECTION in
    *"󰌾 Lock"*)
        swaylock;;
    *"󰤄 Suspend"*)
        if confirm_action "Suspend"; then
            systemctl suspend
        fi;;
    *"󰍃 Log out"*)
        if confirm_action "Log out"; then
            swaymsg exit
        fi;;
    *" Reboot"*)
        if confirm_action "Reboot"; then
            systemctl reboot
        fi;;
    *" Reboot to UEFI"*)
        if confirm_action "Reboot to UEFI"; then
            systemctl reboot --firmware-setup
        fi;;
    *"󰐥 Shutdown"*)
        if confirm_action "Shutdown"; then
            systemctl poweroff
        fi;;
esac
