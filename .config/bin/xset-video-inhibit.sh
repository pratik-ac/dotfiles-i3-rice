#!/bin/bash

# Track current state
inhibited=0

while true; do
    # Get the title and class of the focused window
    win_id=$(xdotool getwindowfocus 2>/dev/null)
    title=$(xdotool getwindowfocus getwindowname 2>/dev/null)
    class=$(xprop -id "$win_id" WM_CLASS 2>/dev/null)

    # Check if the window is fullscreen
    is_fullscreen=$(xprop -id "$win_id" | grep "_NET_WM_STATE_FULLSCREEN")

    # If a fullscreen video-related window is detected
    if [[ "$is_fullscreen" ]] && echo "$title $class" | grep -iE 'YouTube|firefox|chromium|vlc|mpv'; then
        if [[ $inhibited -eq 0 ]]; then
            echo "[xset] Inhibiting screen lock"
            xset s off -dpms
            inhibited=1
        fi
    else
        if [[ $inhibited -eq 1 ]]; then
            echo "[xset] Re-enabling screen lock"
            xset s on +dpms
            inhibited=0
        fi
    fi

    sleep 10
done
