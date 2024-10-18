#!/bin/bash

# Define theme directory and repository
THEME_DIR="~/printer_data/config/.theme"
REPO_URL="https://github.com/ApexInvent/apex-invent-mainsail-theme.git"
MOONRAKER_CONFIG="~/printer_data/config/moonraker.conf"

# Add update manager entry to moonraker.conf
echo "Adding update manager configuration to moonraker.conf..."
CONFIG_ENTRY="\n[update_manager apex_invent_theme]\ntype: git_repo\npath: $THEME_DIR\norigin: $REPO_URL"
if echo -e "$CONFIG_ENTRY" | sudo tee -a "$MOONRAKER_CONFIG" > /dev/null; then
    echo "Successfully added update manager entry to moonraker.conf."
else
    echo "Failed to add update manager entry." >&2
    exit 1
fi

# Restart Moonraker service
echo "Restarting Moonraker service..."
if sudo service moonraker restart; then
    echo "Moonraker service restarted successfully."
else
    echo "Failed to restart Moonraker service." >&2
    exit 1
fi

echo "Configuration complete."
