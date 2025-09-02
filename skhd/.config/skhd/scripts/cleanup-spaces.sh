#!/bin/bash

# Get current focused space to restore focus later
current_space=$(yabai -m query --spaces --space | jq -r '.index')

# Get all space IDs that have no windows
empty_spaces=$(yabai -m query --spaces | jq -r '.[] | select(.windows | length == 0) | .index' | sort -rn)

# Delete empty spaces (in reverse order to avoid index shifting)
for space in $empty_spaces; do
    # Don't delete if it's the only space left
    total_spaces=$(yabai -m query --spaces | jq '. | length')
    if [ "$total_spaces" -gt 1 ]; then
        yabai -m space "$space" --destroy
    fi
done

# Yabai automatically renumbers spaces sequentially after deletion
# So we just need to focus back on a reasonable space
remaining_spaces=$(yabai -m query --spaces | jq '. | length')
if [ "$current_space" -gt "$remaining_spaces" ]; then
    # If current space was deleted, focus on the last remaining space
    yabai -m space --focus "$remaining_spaces"
else
    # Try to focus back on the original space (or closest available)
    yabai -m space --focus "$current_space" || yabai -m space --focus 1
fi