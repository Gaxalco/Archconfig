#!/bin/bash

# Define the source and destination directories
SRC_DIR="$HOME/.config"
DEST_DIR="$HOME/Bureau/GitHub Projects/Arch Dot Files/src/.config"

# Ensure the destination directory exists
mkdir -p "$DEST_DIR" || { echo "Failed to create destination directory"; exit 1; }

# List of folders to include
FOLDERS=("alacritty" "cava" "btop" "hypr" "fastfetch" "nvim" "ranger" "spicetify" "waybar" "wofi")

# Loop through each folder and copy the contents
for folder in "${FOLDERS[@]}"; do
    if [ -d "$SRC_DIR/$folder" ]; then
        rm -rf "$DEST_DIR/$folder" || { echo "Failed to remove $DEST_DIR/$folder"; exit 1; }
        mkdir -p "$DEST_DIR/$folder" || { echo "Failed to create $DEST_DIR/$folder"; exit 1; }
        cp -r "$SRC_DIR/$folder/." "$DEST_DIR/$folder/" || { echo "Failed to copy $folder"; exit 1; }
        echo "Copied $folder"
    else
        echo "Folder $folder does not exist in $SRC_DIR"
    fi
done

echo "Backup completed."
