# Personal Bash Commands

A collection of personal bash commands to simplify common tasks.

## Commands

### `gitprune`
Checkout to `main` (or `master`), do a `git pull`, and remove local branches that no longer exist on the remote.

**Usage:**
```bash
gitprune
```

### `up`
Update the package lists and upgrade all installed packages using `sudo apt`.

**Usage:**
```bash
up
```

## How to use

To make these commands available in your system, you can add the `bin/` directory to your `PATH`.

1. Copy this repository to your preferred location (e.g., `~/projects/linux-commands`).
2. Run the install script (use `source` to apply changes immediately to your current session):

```bash
source ./install.sh
```

Alternatively, you can manually add the following line to your `~/.bashrc` or `~/.zshrc`:

```bash
export PATH="$PATH:/home/renanlf/workspace/projects/linux-commands/bin"
```

3. Restart your terminal or run `source ~/.bashrc` (or `~/.zshrc`) to apply the changes.
