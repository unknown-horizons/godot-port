#!/bin/sh

# Godot version or path.
GODOT="3.1"

# Look for the Godot binary.
if [ -f "$GODOT" ]; then
    : # Do nothing. It's already a valid path.
elif [ -f "$HOME/.local/share/Godot/$GODOT/Godot" ]; then
    GODOT="$HOME/.local/share/Godot/$GODOT/Godot"
elif [ -f "$HOME/.local/bin/Godot/$GODOT/Godot" ]; then
    GODOT="$HOME/.local/bin/Godot/$GODOT/Godot"
elif [ -f "$HOME/Documents/Godot/$GODOT/Godot" ]; then
    GODOT="$HOME/Documents/Godot/$GODOT/Godot"
else
    echo "Error: Can't find the Godot editor. Can't run. "
    exit 1
fi

# Is this a Godot project?
if [ ! -f "project.godot" ]; then
    echo "Error: This isn't the directory of a Godot project. Can't run. "
    exit 2
fi

# Run
$GODOT --path .
