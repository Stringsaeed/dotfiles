# Homebrew can already be on PATH when launched from an existing shell.
if (( $+commands[brew] )); then
  eval "$(brew shellenv)"
elif [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"

typeset -U path
path=("$HOME/.local/bin" "$BUN_INSTALL/bin" $path "$PNPM_HOME" "$PNPM_HOME/bin")

if [[ -n "${HOMEBREW_PREFIX:-}" && -d "$HOMEBREW_PREFIX/opt/ruby@3.3/bin" ]]; then
  # Prefer Homebrew's isolated executables over gems in the shared Ruby install.
  path=("${(@)path:#$HOMEBREW_PREFIX/lib/ruby/gems/3.3.0/bin}")
  path=("$HOMEBREW_PREFIX/opt/ruby@3.3/bin" $path "$HOMEBREW_PREFIX/lib/ruby/gems/3.3.0/bin")
fi

if [[ -n "${ANDROID_HOME:-}" || -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
  path+=("$ANDROID_HOME/emulator" "$ANDROID_HOME/platform-tools")
fi

if [[ -z "${JAVA_HOME:-}" && -d /Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home ]]; then
  export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
fi

[[ ! -r "$HOME/.zprofile.local" ]] || source "$HOME/.zprofile.local"
