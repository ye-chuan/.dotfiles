#!/bin/sh

# REQUIRES: cbonsai ffmpeg fortune
# Plays bonsai animation with music

music_path="$HOME/.config/scripts/assets/bonsai.opus"

ffplay -v warning -nodisp -autoexit -loop 1000 "${music_path}"&

while true; do
    cbonsai -l -L 50 -M 6 --time=0.25 --wait=10 --message="$(fortune)"
done
