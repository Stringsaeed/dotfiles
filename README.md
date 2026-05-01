# Dotfiles

My macOS development environment.

## What's included

- **Zsh** with Zinit, Starship, plugins (autosuggestions, syntax highlighting, fzf-tab)
- **Ghostty** terminal config with Catppuccin Mocha theme
- **Starship** prompt
- **Git** config with delta diffs

## Setup on a new Mac

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Then create `~/.secrets` with your API keys (see `.zprofile` for what's expected).

## Per-machine overrides

Put anything machine-specific in `~/.zshrc.local` — it won't be tracked.

## Updating

After changing any config, just `git commit && git push` from `~/dotfiles`.
The files in your home directory are symlinks, so edits work in place.
