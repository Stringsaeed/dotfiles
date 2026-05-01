# ============ Homebrew ============
eval "$(/opt/homebrew/bin/brew shellenv)"

# ============ Environment variables ============
export ANDROID_HOME="$HOME/Library/Android/sdk"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/Library/pnpm"
export NVM_DIR="$HOME/.nvm"

# ============ PATH (single source of truth) ============
path=(
  "$HOME/.local/bin"
  "$PNPM_HOME"
  "$BUN_INSTALL/bin"
  "$HOME/.flashlight/bin"
  "/opt/homebrew/opt/ruby@3.3/bin"
  "/opt/homebrew/lib/ruby/gems/3.3.0/bin"
  "$ANDROID_HOME/emulator"
  "$ANDROID_HOME/platform-tools"
  $path
)
typeset -U path  # auto-deduplicate
