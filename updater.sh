#!/bin/bash

# Created by Apex Invent
# Define theme directory and repository
THEME_DIR="$HOME/printer_data/config/.theme"
REPO_URL="https://github.com/ApexInvent/apex-invent-mainsail-theme.git"
MOONRAKER_CONFIG="$HOME/printer_data/config/moonraker.conf"

# Verify if Moonraker config file exists
if [ ! -f "$MOONRAKER_CONFIG" ]; then
    echo "Error: Moonraker config file not found at $MOONRAKER_CONFIG"
    exit 1
fi

# Clone the theme into the theme directory if it doesn't already exist
if [ -d "$THEME_DIR" ]; then
    echo "Theme directory already exists. Pulling latest changes..."
    cd "$THEME_DIR" && git pull || {
        echo "Failed to update the theme repository." >&2
        exit 1
    }
else
    echo "Cloning the Apex Invent Mainsail Theme into $THEME_DIR..."
    if git clone "$REPO_URL" "$THEME_DIR"; then
        echo "Successfully cloned the repository."
    else
        echo "Failed to clone the repository." >&2
        exit 1
    fi
fi

# Add update manager entry to moonraker.conf if it doesn't already exist
if grep -q "update_manager apex_invent_theme" "$MOONRAKER_CONFIG"; then
    echo "Update manager entry already exists in moonraker.conf. Skipping addition."
else
    echo "Adding update manager configuration to moonraker.conf..."
    CONFIG_ENTRY="\n[update_manager apex_invent_theme]\ntype: git_repo\npath: $THEME_DIR\norigin: $REPO_URL"
    if echo -e "$CONFIG_ENTRY" | tee -a "$MOONRAKER_CONFIG" > /dev/null; then
        echo "Successfully added update manager entry to moonraker.conf."
    else
        echo "Failed to add update manager entry." >&2
        exit 1
    fi
fi

# Restart Moonraker service
echo "Restarting Moonraker service..."
if sudo service moonraker restart; then
    echo "Moonraker service restarted successfully."
else
    echo "Failed to restart Moonraker service." >&2
    exit 1
fi

echo "Installation complete."
