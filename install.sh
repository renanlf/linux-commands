#!/bin/bash

# install.sh: Adds the bin directory of this project to the user's PATH.

PROJECT_BIN_DIR="$(cd "$(dirname "$0")" && pwd)/bin"

# Determine which config file to use
if [[ "$SHELL" == */zsh ]]; then
    CONFIG_FILE="$HOME/.zshrc"
elif [[ "$SHELL" == */bash ]]; then
    CONFIG_FILE="$HOME/.bashrc"
else
    echo "Unsupported shell: $SHELL. Please manually add $PROJECT_BIN_DIR to your PATH."
    exit 1
fi

# Check if the PATH is already exported in the config file
if grep -q "$PROJECT_BIN_DIR" "$CONFIG_FILE"; then
    echo "The directory $PROJECT_BIN_DIR is already in your $CONFIG_FILE."
else
    echo "Adding $PROJECT_BIN_DIR to $CONFIG_FILE..."
    echo "" >> "$CONFIG_FILE"
    echo "# Personal Bash Commands" >> "$CONFIG_FILE"
    echo "export PATH="\$PATH:$PROJECT_BIN_DIR"" >> "$CONFIG_FILE"
    
    echo "Installation complete!"
    echo "Sourcing $CONFIG_FILE to apply changes..."
    source "$CONFIG_FILE"
    echo "Done! If the command is not available, please restart your terminal or run 'source $CONFIG_FILE'."
fi
