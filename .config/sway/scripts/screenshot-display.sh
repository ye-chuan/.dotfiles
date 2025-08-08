#!/bin/bash

# Script using (grim, slurp, swappy) to screenshot a display

output_id=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused).name')
grim -o $output_id - | swappy -f -
