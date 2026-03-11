# Project Overview
This is a collection of personal Bash commands (`linux-commands`) designed to simplify common terminal tasks on Linux. The project consists of standalone executable scripts located in the `bin/` directory.

- **`gitprune`**: Checks out the `main` or `master` branch, pulls the latest changes, and prunes local branches that no longer exist on the remote repository.
- **`up`**: Updates package lists and upgrades all installed packages using `sudo apt`.

# Building and Running
As a collection of Bash scripts, there is no formal build process. The scripts are intended to be installed globally on the user's system by adding the `bin/` directory to the shell's `PATH`.

- **Installation/Updating**:
  Run the `install.sh` script or use the `curl` one-liner. It clones the repository to `~/.linux-commands`, installs `zsh` and `oh-my-zsh`, sets `zsh` as the default shell, copies the project's `.zshrc` configuration, and updates the `PATH`.
  ```bash
  curl -sSL https://raw.githubusercontent.com/renanlf/linux-commands/main/install.sh | bash
  ```

- **Execution**:
  Once installed, the commands can be executed from any directory:
  ```bash
  gitprune
  up
  ```

# Development Conventions
- **Language**: Scripts are written in Bash (`#!/bin/bash`).
- **File Structure**: Executable scripts must be placed in the `bin/` directory. They should lack file extensions (e.g., `up`, not `up.sh`) for cleaner command invocation.
- **Output Management**: Standard operations (like git checkouts or fetches) tend to suppress unnecessary output (`> /dev/null 2>&1`), providing only relevant and essential feedback to the user.
- **Style**: Scripts should be concise, focused on a single responsibility, and clearly commented.