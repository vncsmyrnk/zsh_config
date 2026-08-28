# zmodload zsh/zprof # uncomment for profiling debug

# zsh compinit cache
ZSH_COMPDUMP="$HOME/.zshcompdump"

HISTFILE="$HOME/.zsh_history"
unsetopt HIST_SAVE_BY_COPY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHDMINUS

# Defines environment variables and PATH
[ -f ~/.zprofile ] && \. ~/.zprofile

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" &&
    print -P "%F{33} %F{34}Installation successful.%f%b" ||
    print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
((${+_comps})) && _comps[zinit]=_zinit

zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust

zinit ice from"gh-r" as"program" mv"posh-* -> oh-my-posh" \
  atclone"chmod a+x oh-my-posh; ./oh-my-posh init zsh --config $HOME/.config.omp.json > init.zsh" \
  atpull"%atclone" src"init.zsh"
zinit light jandedobbeleer/oh-my-posh

zinit ice from"gh-r" as"program" \
  atclone"./zoxide init zsh > init.zsh" \
  atpull"%atclone" src"init.zsh"
zinit light ajeetdsouza/zoxide

zinit ice pick"config/aliases"
zinit light vncsmyrnk/git-config

zinit ice pick"config/aliases"
zinit light vncsmyrnk/tmux-config

zinit ice pick"aliases"
zinit light vncsmyrnk/utilities

zinit ice depth"1"
zinit light zsh-users/zsh-autosuggestions

zinit ice depth"1" wait lucid
zinit light zdharma-continuum/fast-syntax-highlighting

zinit snippet OMZL::completion.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh

ZINIT_CUSTOM_SNIPPETS="$HOME/.cache/zinit-custom-snippets"
zinit-cached-snippet() {
  if ! command -v "$1" >/dev/null; then
    return
  fi
  local slug=$(tr -cs '[:alnum:]' '-' <<<"$@")
  local cache_path="$ZINIT_CUSTOM_SNIPPETS/$slug.zsh"
  if [[ ! -f "$cache_path" ]]; then
    mkdir -p "$ZINIT_CUSTOM_SNIPPETS"
    "$@" >"$cache_path"
  fi
  zinit snippet "$cache_path"
}
zinit-cached-snippet luarocks path --lua-version=5.1

zinit ice wait lucid
zinit snippet OMZP::fzf

zinit ice wait lucid
zinit snippet OMZP::common-aliases

zinit ice wait lucid
zinit snippet OMZP::git

zinit ice wait lucid
zinit snippet OMZP::kubectl

# The fpath environment variable in zsh specifies a list
# of directories that the shell searches for function definitions.
[ -n $HOMEBREW_PREFIX ] && fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)
[ -d $HOME/.nix-profile/share/zsh/site-functions ] &&
  fpath=($HOME/.nix-profile/share/zsh/site-functions $fpath)
[ -d $HOME/.local/share/zsh/site-functions ] &&
  fpath=($HOME/.local/share/zsh/site-functions $fpath)

# Apps specs
[ -s "$HOME/.gvm/scripts/gvm" ] && {
  zsh-defer \. "$HOME/.gvm/scripts/gvm"
  zsh-defer unset -f cd
}
[ -s "$HOME/.nvm/nvm.sh" ] && zsh-defer \. "$HOME/.nvm/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ] &&
  \. "$HOME/google-cloud-sdk/path.zsh.inc"
[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ] &&
  \. "$HOME/google-cloud-sdk/completion.zsh.inc"
[ -x /home/linuxbrew/.linuxbrew/bin/brew ] &&
  \. <(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# Sources aliases
[ -f ~/.zsh_aliases ] && \. ~/.zsh_aliases

# Binds
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey -s '^Z' 'exec zsh\n'

autoload -Uz compinit
compinit -C -d "$ZSH_COMPDUMP"

{ # updates completions file in a non-blocking way
  setopt NO_NOTIFY NO_MONITOR
  (compinit -d "$ZSH_COMPDUMP") &
} >/dev/null

# Source extra files
[ -f ~/.zshrc.private ] && \. ~/.zshrc.private
[ -f ~/.env ] && \. ~/.env

true
# zprof # uncomment for profiling debug
