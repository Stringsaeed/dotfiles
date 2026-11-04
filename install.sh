#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
packages=(zsh ghostty starship git zed atuin ssh)
mode="${1:-}"

case "$mode" in
  ""|--link-only|--dry-run) ;;
  *)
    printf 'Usage: %s [--link-only | --dry-run]\n' "$0" >&2
    exit 2
    ;;
esac

link_configs() {
  stow --dir="$DOTFILES_DIR" --target="$HOME" "$@" --stow "${packages[@]}"
}

if [[ "$mode" == --dry-run ]]; then
  link_configs --simulate --verbose
  exit
fi

# Check existing files before installing dependencies when Stow is available.
if command -v stow >/dev/null 2>&1; then
  link_configs --simulate
fi

if [[ "$mode" != --link-only ]]; then
  if ! xcode-select -p >/dev/null 2>&1; then
    xcode-select --install
    printf 'Rerun this script after the Xcode Command Line Tools finish installing.\n'
    exit
  fi

  if ! command -v brew >/dev/null 2>&1; then
    if [[ ! -x /opt/homebrew/bin/brew && ! -x /usr/local/bin/brew ]]; then
      brew_installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      /bin/bash -c "$brew_installer"
    fi
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi

  HOMEBREW_BUNDLE_NO_UPGRADE=1 brew bundle --file="$DOTFILES_DIR/Brewfile"
  "$DOTFILES_DIR/setup-fonts.sh"

  zinit_dir="$HOME/.local/share/zinit/zinit.git"
  if [[ ! -f "$zinit_dir/zinit.zsh" ]]; then
    mkdir -p "$(dirname "$zinit_dir")"
    git clone https://github.com/zdharma-continuum/zinit "$zinit_dir"
  fi
fi

link_configs --simulate

# Keep directories owned by the apps so generated files stay outside the repo.
mkdir -p "$HOME/.config/"{atuin,ghostty,git,zed}
if [[ ! -d "$HOME/.ssh" ]]; then
  mkdir -m 700 "$HOME/.ssh"
fi

link_configs
printf 'Linked dotfiles. Open a new shell to load them.\n'
