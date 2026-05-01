#!/usr/bin/env bash
set -e

DOTFILES_DIR="$HOME/dotfiles"
cd "$DOTFILES_DIR"

# 1. Install Homebrew if missing
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2. Install everything from Brewfile
echo "Installing brew packages..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# 3. Install Zinit
if [ ! -d "$HOME/.local/share/zinit/zinit.git" ]; then
  echo "Installing Zinit..."
  bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)" -- --no-edit
fi

# 4. Backup any existing dotfiles that aren't symlinks
echo "Backing up existing dotfiles..."
for f in .zshrc .zprofile .gitconfig; do
  if [ -f "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
    mv "$HOME/$f" "$HOME/$f.backup.$(date +%s)"
  fi
done

# 5. Stow all packages
echo "Linking dotfiles..."
for pkg in zsh ghostty starship git; do
  stow -R "$pkg"
done

# 6. Set up secrets file if missing
if [ ! -f "$HOME/.secrets" ]; then
  echo "Creating ~/.secrets template..."
  cat > "$HOME/.secrets" << 'SECRETS'
# Add your API keys here
# export OPENAI_API_KEY=""
SECRETS
  chmod 600 "$HOME/.secrets"
fi

echo "✅ Done! Restart your terminal."
