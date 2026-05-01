#!/usr/bin/env bash
set -e

DOTFILES_DIR="$HOME/dotfiles"
cd "$DOTFILES_DIR"

# 1. Xcode Command Line Tools
if ! xcode-select -p &> /dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "Press Enter once the installer finishes..."
  read -r
fi

# 2. Install Homebrew if missing
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 3. Install everything from Brewfile
echo "Installing brew packages..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# 4. Install Zinit
if [ ! -d "$HOME/.local/share/zinit/zinit.git" ]; then
  echo "Installing Zinit..."
  bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)" -- --no-edit
fi

# 5. Backup any existing dotfiles/configs that aren't symlinks
echo "Backing up existing dotfiles..."
TIMESTAMP=$(date +%s)
for f in .zshrc .zprofile .gitconfig; do
  if [ -f "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
    mv "$HOME/$f" "$HOME/$f.backup.$TIMESTAMP"
  fi
done
for d in ghostty starship zed atuin nvim; do
  target="$HOME/.config/$d"
  if [ -d "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.backup.$TIMESTAMP"
  fi
done
if [ -f "$HOME/.ssh/config" ] && [ ! -L "$HOME/.ssh/config" ]; then
  mv "$HOME/.ssh/config" "$HOME/.ssh/config.backup.$TIMESTAMP"
fi

# 6. Stow all packages
echo "Linking dotfiles..."
mkdir -p "$HOME/.config" "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
for pkg in zsh ghostty starship git zed atuin ssh nvim; do
  stow -R "$pkg"
done

# 7. Set up secrets file if missing
if [ ! -f "$HOME/.secrets" ]; then
  echo "Creating ~/.secrets template..."
  cat > "$HOME/.secrets" << 'SECRETS'
# Add your API keys here
# export OPENAI_API_KEY=""
SECRETS
  chmod 600 "$HOME/.secrets"
fi

echo "✅ Done! Restart your terminal."
