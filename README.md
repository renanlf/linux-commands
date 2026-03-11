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

## How to Install or Update

To install these commands or update existing ones, run the following command in your terminal:

```bash
curl -sSL https://raw.githubusercontent.com/renanlf/linux-commands/main/install.sh | bash
```

This will:
1. Clone (or update) this repository to `~/.linux-commands`.
2. Install `zsh` and `oh-my-zsh` if they are not already installed.
3. Set `zsh` as your default shell.
4. Copy the repository's `.zshrc` file to your home directory (backing up any existing `.zshrc`).
5. Add the `bin/` directory to your `PATH` in `~/.zshrc`.

After installation, restart your terminal or log out and back in to use Zsh.
