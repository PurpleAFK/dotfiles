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

# functions
cpp() { g++ "$1" && ./a.out; }

tf() {
  if [ -z "$1" ]; then
    echo "Usage: tf /path/to/project [session-name]"
    return 1
  fi
  local session_name="${2:-programming}"
  PROJECT_DIR="$1" tmuxifier load-session "$session_name"
}

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

# tmuxifier
alias tls="tmuxifier load-session"
alias tlw="tmuxifier load-window"
alias tns="tmuxifier new-session"
alias tnw="tmuxifier new-window"

# scripts
alias t="$HOME/.config/scripts/fzf-tmux.sh"
alias sw="$HOME/.config/scripts/set-wall.sh"
alias w="$HOME/.config/scripts/wallpaper-chooser.sh"

maintenance() {
    sudo "$HOME/.config/scripts/maintenance.sh" "$@" # doing this because cant use sudo with an alias
}

# clear
alias cls="clear"
# exit
alias e="exit"


# running code
alias cfs="g++ -std=c++17 -Wall -Wextra solution.cpp -o solution && ./solution < in.txt"
alias cft="g++ -std=c++17 -Wall -Wextra solution.cpp -o solution && echo -ne '\\e[0;34m' && ./solution < test.txt; echo -ne '\\e[0m'"
alias cfc="cft; echo; cfs"
alias cfp="g++ -std=c++17 -Wall -Wextra solution.cpp -o solution" # for compiling only

# advent-of-code

AOC="~/Documents/advent-of-code/"
AOC_COOKIE="53616c7465645f5fba2f28abb16822925bee86e78617ea5fe977759fdd47b5a52b4bca4ec9a98947a33e9a3a60e1a82d1109d174ee4ac72def3e931921bfcafe" # get this from the cookies tab in network tools on the AOC website

alias aos="cd $AOC && g++ -std=c++17 -Wall -Wextra solution.cpp -o solution && ./solution < in.txt"
alias aot="cd $AOC && g++ -std=c++17 -Wall -Wextra solution.cpp -o solution && echo -ne '\\e[0;34m' && ./solution < test.txt; echo -ne '\\e[0m'"
alias aoc="paot; echo; paos"
alias aocp="cd $AOC && g++ -std=c++17 -Wall -Wextra solution.cpp -o solution" # for compiling only

alias paos="cd $AOC; python3 solution.py < in.txt"
alias paot="cd $AOC; echo -ne '\\e[0;34m'; python3 solution.py < test.txt; echo -ne '\\e[0m'"
alias paoc="aot; echo; aos"

function aoc-load () {
    if [ $1 ]
    then
        curl --cookie "session=$AOC_COOKIE" https://adventofcode.com/$1/day/$2/input > in.txt
    else
        curl --cookie "session=$AOC_COOKIE" "$(echo `date +https://adventofcode.com/%Y/day/%d/input` | sed 's/\/0/\//g')" > in.txt
    fi
}

# Shell Integrations
export PATH="$HOME/.tmuxifier/bin:$PATH"
eval "$(tmuxifier init -)"
export PATH=$PATH:/home/purpleafk/.local/bin
export PATH=$PATH:/home/purpleafk/.cargo/bin
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/pywal-theme.omp.json)"
source $HOME/.config/scripts/fzf-git.sh
source /home/purpleafk/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval "$(zoxide init zsh)"
source <(fzf --zsh)
