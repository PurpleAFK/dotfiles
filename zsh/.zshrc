autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Plugin Manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Plugins
# Prompt styles
#zinit light nullxception/roundy  
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# FZF
# Set up fzf key bindings and fuzzy completion
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"

# Setup fzf previews
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"

# fzf preview for tmux
export FZF_TMUX_OPTS=" -p90%,70% " 

# Aliases
alias ls="eza --no-filesize --long --color=always --icons=always --no-user"
alias ll="ls -la"
# git aliases
alias git="git"
alias ga="git add ."
alias gs="git status -s"
alias gc='git commit -m'
alias glog='git log --oneline --graph --all'
# yazi
alias y="yazi"
# nvim
alias nv="nvim"
alias fu="fd --type f --hidden --exclude .git | fzf-tmux -p --reverse| xargs nvim"
# tmux
alias t="tmux"
alias tn="tmux new -s"
alias ta="tmux attach -t"
alias td="tmux detach"
alias tk="tmux kill-session -t"

# scripts
alias t="$HOME/.config/scripts/fzf-tmux.sh"
alias sw="$HOME/.config/scripts/set-wall.sh"
alias w="$HOME/.config/scripts/wallpaper-chooser.sh"

# clear
alias cls="clear"
# exit
alias e="exit"


# Shell Integrations
export PATH=$PATH:/home/purpleafk/.local/bin
export PATH=$PATH:/home/purpleafk/.cargo/bin
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/pywal-theme.omp.json)"
source $HOME/.config/scripts/fzf-git.sh
source /home/purpleafk/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval "$(zoxide init zsh)"
source <(fzf --zsh)
