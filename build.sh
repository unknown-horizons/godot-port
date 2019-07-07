#!/bin/sh

# Change to the project's name.
PROJECTNAME="UnknownHorizons"
# Godot version or path.
GODOT="3.1"

# Note: This script expects the export presets to be called "windows" and "linux".

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
else
    echo "Error: Can't find the Godot editor. Can't build. "
    exit 1
fi

# Is this a Godot project?
if [ ! -f "project.godot" ]; then
    echo "Error: This isn't the directory of a Godot project. Can't build. "
    exit 2
fi
if [ ! -f "export_presets.cfg" ]; then
    echo "Error: There isn't an export presets file. Can't build. "
    exit 3
fi

# Ensure folder structure exists.
mkdir -p "Builds/Desktop"

# Builds.
$GODOT --path . --export linux "Builds/Desktop/$PROJECTNAME.x86_64"
$GODOT --path . --export windows "Builds/Desktop/$PROJECTNAME.exe"

# Make everything executable.
chmod -R +x Builds/*

# Check if the files exist, if not, throw an error.
if [ ! -f "Builds/Desktop/$PROJECTNAME.x86_64" ] || [ ! -f "Builds/Desktop/$PROJECTNAME.exe" ]; then
    echo
    echo "Error: Building failed! Please see the Godot log for more information. "
    echo
    exit 4
fi

echo
echo "SUCCESS building the project! "
echo


