# ============ Node.js ==============
export NVM_DIR="${NVM_DIR:-${XDG_CONFIG_HOME:+$XDG_CONFIG_HOME/nvm}}"
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
elif [[ -n "${HOMEBREW_PREFIX:-}" && -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]]; then
  source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
fi

if (( $+functions[nvm] )); then
  autoload -Uz add-zsh-hook

  load-nvmrc() {
    local nvmrc_path
    nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version
      nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
        nvm use
      fi
    elif [ -n "$(PWD=${OLDPWD:-$PWD} nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
      echo "Reverting to nvm default version"
      nvm use default
    fi
  }

  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi

# ============ Prompt ============
if (( $+commands[starship] )); then eval "$(starship init zsh)"; fi

# ============ Zinit ============
if [[ -r "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
  source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit

  # Zinit annexes
  zinit light-mode for \
      zdharma-continuum/zinit-annex-as-monitor \
      zdharma-continuum/zinit-annex-bin-gem-node \
      zdharma-continuum/zinit-annex-patch-dl \
      zdharma-continuum/zinit-annex-rust

  # ============ Plugins (turbo-loaded) ============
  zinit wait lucid for \
    atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
      zdharma-continuum/fast-syntax-highlighting

  zinit light Aloxaf/fzf-tab
fi

# ============ History ============
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE SHARE_HISTORY \
       HIST_REDUCE_BLANKS INC_APPEND_HISTORY HIST_VERIFY

# ============ Options ============
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt INTERACTIVE_COMMENTS GLOB_DOTS EXTENDED_GLOB

# ============ Tool integrations ============
if (( $+commands[zoxide] )); then eval "$(zoxide init zsh)"; fi
if (( $+commands[fzf] )); then eval "$(fzf --zsh)"; fi
if (( $+commands[atuin] )); then eval "$(atuin init zsh)"; fi

# ============ Bun completions ============
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# ============ GPG (for signed commits) ============
if [[ -t 0 ]]; then export GPG_TTY=$(tty); fi

# ============ Keybindings ============
bindkey '^[[C' autosuggest-accept       # → accepts autosuggestion
bindkey '^[[1;5C' forward-word          # Ctrl+→
bindkey '^[[1;5D' backward-word         # Ctrl+←

# ============ Aliases ============
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --git --group-directories-first'
alias la='eza -lah --icons --git --group-directories-first'
alias tree='eza --tree --icons'
alias cat='bat --paging=never'
alias grep='rg'
alias find='fd'
alias top='btop'
alias du='dust'
alias df='duf'
alias cd='z'

# Git
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias glog='git log --oneline --graph --decorate'
alias lg='lazygit'

# React Native
alias rni='npx react-native run-ios'
alias rna='npx react-native run-android'
alias rns='npx react-native start'
alias rnsr='npx react-native start --reset-cache'
alias podi='cd ios && pod install && cd ..'

# ============ fzf-tab styling ============
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --line-range :50 $realpath 2>/dev/null || eza -1 --color=always --icons $realpath'
zstyle ':fzf-tab:*' switch-group ',' '.'

# Per-machine integrations and environment.
[[ ! -r "$HOME/.zshrc.local" ]] || source "$HOME/.zshrc.local"
