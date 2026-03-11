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

# Install zsh if it's not installed
if ! command -v zsh >/dev/null 2>&1; then
    echo "Zsh is not installed. Attempting to install zsh..."
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update && sudo apt-get install -y zsh
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y zsh
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --noconfirm zsh
    else
        echo "Could not find a supported package manager to install zsh. Please install zsh manually."
        exit 1
    fi
fi

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Set zsh as default shell
if [ "$SHELL" != "$(command -v zsh)" ]; then
    echo "Setting zsh as the default shell..."
    # chsh without sudo is preferred but often requires password. We use standard chsh.
    # If standard chsh fails, we try sudo chsh.
    if ! chsh -s "$(command -v zsh)" "$USER"; then
        sudo chsh -s "$(command -v zsh)" "$USER"
    fi
fi

# Copy the .zshrc from the repo
if [ -f "$INSTALL_DIR/config/.zshrc" ]; then
    echo "Copying repository config/.zshrc to ~/.zshrc..."
    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%Y%m%d%H%M%S)"
    fi
    cp "$INSTALL_DIR/config/.zshrc" "$HOME/.zshrc"
fi

CONFIG_FILE="$HOME/.zshrc"

# Ensure config file exists (should exist now, but just in case)
touch "$CONFIG_FILE"

# Check if the PATH is already exported in the config file
if ! grep -q "$PROJECT_BIN_DIR" "$CONFIG_FILE"; then
    echo "Configuring PATH in $CONFIG_FILE..."
    echo "" >> "$CONFIG_FILE"
    echo "# Personal Bash Commands" >> "$CONFIG_FILE"
    echo "export PATH=\"\$PATH:$PROJECT_BIN_DIR\"" >> "$CONFIG_FILE"
fi

# --- Install APT Dependencies ---
if command -v apt-get >/dev/null 2>&1; then
    APT_PACKAGES_FILE="$INSTALL_DIR/config/apt-packages.txt"
    APT_PPAS_FILE="$INSTALL_DIR/config/apt-ppas.txt"

    # Handle PPAs
    if [ -f "$APT_PPAS_FILE" ]; then
        echo "Checking for PPAs..."
        ppa_added=false
        # Ensure software-properties-common is installed for add-apt-repository
        if ! dpkg-query -W -f='${Status}' software-properties-common 2>/dev/null | grep -q "ok installed"; then
            echo "Installing software-properties-common for PPA support..."
            sudo apt-get update && sudo apt-get install -y software-properties-common
        fi

        while IFS= read -r ppa || [ -n "$ppa" ]; do
            # Skip empty lines and comments
            [[ -z "$ppa" || "$ppa" =~ ^#.*$ ]] && continue
            echo "Adding PPA: $ppa"
            sudo add-apt-repository -y "$ppa"
            ppa_added=true
        done < "$APT_PPAS_FILE"

        if [ "$ppa_added" = true ]; then
            sudo apt-get update
        fi
    fi

    # Handle Packages
    if [ -f "$APT_PACKAGES_FILE" ]; then
        echo "Checking for missing APT packages..."
        missing_packages=""
        while IFS= read -r pkg || [ -n "$pkg" ]; do
            # Skip empty lines and comments
            [[ -z "$pkg" || "$pkg" =~ ^#.*$ ]] && continue
            if ! dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "ok installed"; then
                missing_packages="$missing_packages $pkg"
            fi
        done < "$APT_PACKAGES_FILE"

        if [ -n "$missing_packages" ]; then
            echo "Installing missing packages:$missing_packages"
            sudo apt-get install -y $missing_packages
        else
            echo "All configured APT packages are already installed."
        fi
    fi
fi

echo "--------------------------------------------------"
echo "Installation/Update complete!"
echo "Please restart your terminal or log out and back in to use Zsh."
echo "--------------------------------------------------"