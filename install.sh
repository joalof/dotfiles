#!/bin/bash

# List of folders to skip
skip_folders=("vim" "tmux")

for folder in */; do
    if [ -d "$folder" ]; then
        # Check if the folder is in the skip list
        if [[ " ${skip_folders[@]} " =~ " ${folder%/} " ]]; then
            echo "Skipping package: $folder"
            continue
        fi

        echo "Installing package: $folder"
        stow $folder
    fi
done
