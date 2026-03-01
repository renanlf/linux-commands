#!/bin/bash

# install.sh: One-liner installation script for personal linux-commands.
# Usage: curl -sSL https://raw.githubusercontent.com/renanlf/linux-commands/main/install.sh | bash

set -e

INSTALL_DIR="$HOME/.linux-commands"
REPO_URL="https://github.com/renanlf/linux-commands.git"

# Check if git is installed
if ! command -v git >/dev/null 2>&1; then
    echo "Error: git is not installed. Please install git and try again."
    exit 1
fi

if [ -d "$INSTALL_DIR" ]; then
    echo "Updating commands..."
    cd "$INSTALL_DIR"
    git fetch origin main >/dev/null 2>&1
    git reset --hard origin/main >/dev/null 2>&1
else
    echo "Installing commands..."
    git clone "$REPO_URL" "$INSTALL_DIR" >/dev/null 2>&1
fi

PROJECT_BIN_DIR="$INSTALL_DIR/bin"

# Determine which config file to use
if [[ "$SHELL" == */zsh ]]; then
    CONFIG_FILE="$HOME/.zshrc"
elif [[ "$SHELL" == */bash ]]; then
    CONFIG_FILE="$HOME/.bashrc"
else
    # Fallback to .bashrc if shell is unknown but bash is being used to run this
    CONFIG_FILE="$HOME/.bashrc"
fi

# Ensure config file exists
touch "$CONFIG_FILE"

# Check if the PATH is already exported in the config file
if ! grep -q "$PROJECT_BIN_DIR" "$CONFIG_FILE"; then
    echo "Configuring PATH in $CONFIG_FILE..."
    echo "" >> "$CONFIG_FILE"
    echo "# Personal Bash Commands" >> "$CONFIG_FILE"
    echo "export PATH=\"\$PATH:$PROJECT_BIN_DIR\"" >> "$CONFIG_FILE"
fi

echo "--------------------------------------------------"
echo "Installation/Update complete!"
echo "Please restart your terminal or run:"
echo "  source $CONFIG_FILE"
echo "--------------------------------------------------"
