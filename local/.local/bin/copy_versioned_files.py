#!/usr/bin/env python
import os
import shutil
import re
import argparse

def copy_latest_subfolders(source_dir, dest_dir):
    """
    Copies only the latest version of each subfolder to a new destination.
    """
    # Validate source directory
    if not os.path.isdir(source_dir):
        print(f"❌ Error: Source directory '{source_dir}' does not exist or is not a directory.")
        return

    # Create destination directory if it doesn't exist
    os.makedirs(dest_dir, exist_ok=True)
    print(f"✅ Ensured destination directory '{dest_dir}' exists.")

    latest_versions = {} # Dictionary to store the latest version of each base name

    # --- SIMPLIFIED LOGIC ---
    # First, iterate through all directories and identify the latest version for each base name.
    for item_name in os.listdir(source_dir):
        item_path = os.path.join(source_dir, item_name)

        if not os.path.isdir(item_path):
            continue # Skip files, symlinks, etc.

        # Regex to find the base name and version number.
        match = re.match(r"^(.*?)-v([0-9]+)(.*)$", item_name)

        if match:
            # This is a versioned folder (e.g., 'adbreaks-v10').
            base_name = match.group(1)
            version = int(match.group(2))
        else:
            # This is a non-versioned folder (e.g., 'genre', 'metadata').
            base_name = item_name
            version = -1 # Assign a sentinel value lower than any real version.

        # Check if we should update the folder for this base_name.
        # A folder is "better" if:
        # 1. Its version number is higher.
        # 2. Its version is the same, but its full name is lexicographically greater (for tie-breaking).
        if base_name not in latest_versions or \
           version > latest_versions[base_name]['version'] or \
           (version == latest_versions[base_name]['version'] and item_name > latest_versions[base_name]['full_name']):
            latest_versions[base_name] = {
                'version': version,
                'full_path': item_path,
                'full_name': item_name
            }

    print("\n🔎 Identified latest versions for copying:")
    # Sort items by name for cleaner output
    for base_name in sorted(latest_versions.keys()):
        info = latest_versions[base_name]
        version_str = f"v{info['version']}" if info['version'] != -1 else "non-versioned"
        print(f"  - {info['full_name']} (Base: '{base_name}', Version: {version_str})")

    print(f"\n🚀 Starting copy operation to {dest_dir}...")
    copied_count = 0
    for base_name, info in latest_versions.items():
        source_path = info['full_path']
        destination_path = os.path.join(dest_dir, info['full_name'])

        # Avoid overwriting if a folder somehow already exists in the destination
        if os.path.exists(destination_path):
            print(f"⚠️ Skipping '{info['full_name']}', destination already exists.")
            continue
            
        try:
            print(f"Copying: '{info['full_name']}'")
            shutil.copytree(source_path, destination_path)
            copied_count += 1
        except (shutil.Error, OSError) as e:
            print(f"❌ Error copying '{info['full_name']}': {e}")

    print(f"\n✅ Copying complete. Total folders copied: {copied_count}")

def main():
    """
    Main function to parse command-line arguments and run the copy operation.
    """
    parser = argparse.ArgumentParser(
        description="Copies the latest version of each subfolder to a destination directory."
    )
    parser.add_argument(
        "source_directory",
        type=str,
        help="The path to the source directory containing the subfolders."
    )
    parser.add_argument(
        "destination_directory",
        type=str,
        help="The path to the destination directory where latest subfolders will be copied."
    )
    args = parser.parse_args()
    copy_latest_subfolders(args.source_directory, args.destination_directory)

if __name__ == "__main__":
    main()
