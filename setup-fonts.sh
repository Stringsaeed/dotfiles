#!/usr/bin/env bash
set -euo pipefail

# Recognize the official variable and static releases, including manual installs.
for font_dir in "$HOME/Library/Fonts" /Library/Fonts; do
  if [[ -s "$font_dir/PaperMono[wght].ttf" ||
        -s "$font_dir/PaperMono-Regular.otf" ||
        -s "$font_dir/PaperMono-Regular.ttf" ]]; then
    printf 'Paper Mono is already installed.\n'
    exit 0
  fi
done

if command -v brew >/dev/null 2>&1; then
  brew_bin=brew
elif [[ -x /opt/homebrew/bin/brew ]]; then
  brew_bin=/opt/homebrew/bin/brew
elif [[ -x /usr/local/bin/brew ]]; then
  brew_bin=/usr/local/bin/brew
else
  printf 'Homebrew is required to install Paper Mono. Run ./install.sh first.\n' >&2
  exit 1
fi

if "$brew_bin" list --cask font-paper-mono >/dev/null 2>&1; then
  "$brew_bin" reinstall --cask font-paper-mono
else
  "$brew_bin" install --cask font-paper-mono
fi
