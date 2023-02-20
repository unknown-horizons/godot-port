#!/bin/sh

# Godot version or path.
GODOT="3.1"
# Try to find a local godot binary (from repos)
GODOT_LOCAL="`which godot godot3`"
GODOT_LOCAL_PRESENT="$?"
# Look for the Godot binary.
if [ -f "$GODOT" ]; then
    : # Do nothing. It's already a valid path.
elif [ -f "$HOME/.local/share/Godot/$GODOT/Godot" ]; then
    GODOT="$HOME/.local/share/Godot/$GODOT/Godot"
elif [ -f "$HOME/.local/bin/Godot/$GODOT/Godot" ]; then
    GODOT="$HOME/.local/bin/Godot/$GODOT/Godot"
elif [ -f "$HOME/Documents/Godot/$GODOT/Godot" ]; then
    GODOT="$HOME/Documents/Godot/$GODOT/Godot"
# Godot snaps use the "binary-v1-v2" name form
elif [ -f "/snap/bin/godot-${GODOT%%.*}-${GODOT##*.}" ]; then
    GODOT="/snap/bin/godot-${GODOT%%.*}-${GODOT##*.}"
# Godot on macos
elif [ -f "/Applications/Godot.app/Contents/MacOS/Godot" ]; then
    GODOT="/Applications/Godot.app/Contents/MacOS/Godot"
elif [ $GODOT_LOCAL_PRESENT -eq 0 ]; then # which found godot somewhere in $PATH
    GODOT="$GODOT_LOCAL"
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
"$GODOT" --path .
