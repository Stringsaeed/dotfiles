# ============ Zinit ============
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Zinit annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# ============ Prompt ============
eval "$(starship init zsh)"

# ============ Plugins (turbo-loaded) ============
zinit wait lucid for \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting

zinit light Aloxaf/fzf-tab

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
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
eval "$(atuin init zsh)"

# ============ NVM lazy-load ============
# Loads NVM only when you run nvm/node/npm/npx — saves ~300ms
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}
node() { unset -f nvm node npm npx; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; node "$@"; }
npm()  { unset -f nvm node npm npx; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; npm "$@"; }
npx()  { unset -f nvm node npm npx; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; npx "$@"; }

# ============ Bun completions ============
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# ============ GPG (for signed commits) ============
export GPG_TTY=$(tty)

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
