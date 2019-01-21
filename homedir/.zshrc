# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# if [ "$TMUX" = "" ]; then tmux; fi

# Path to your oh-my-zsh installation.
export ZSH=/home/nicolas/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=""
# ZSH_THEME="powerlevel9k/powerlevel9k"
# ZSH_THEME="spaceship"

export TERM="xterm-256color"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git kubectl tmux ssh-agent zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)

PURE_CMD_MAX_EXEC_TIME=1

source $ZSH/oh-my-zsh.sh

# User configuration

# Pure theme set `ZSH_THEME=""` to enable
fpath=( "$HOME/.oh-my-zsh/custom/functions" $fpath )

autoload -U promptinit; promptinit
prompt pure

fpath=( "$HOME/.oh-my-zsh/custom/completion" $fpath)
autoload -Uz compinit && compinit -i

# Remove duplicates form history
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP

# Ignore commands that start with a whitespace from history
setopt histignorespace

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias vim="nvim"
alias v="nvim"

# Aliases / functions leveraging the cb() script
# ----------------------------------------------
# Copy contents of a file
function cbf() { cat "$1" | cb; }  
# Copy SSH public key
alias cbssh="cbf ~/.ssh/id_rsa.pub"  
# Copy current working directory
alias cbwd="pwd | cb"  
# Copy most recent command in bash history
alias cbhs="cat $HISTFILE | tail -n 1 | cb"  

# My path stuff
# -------------
path+=("/sbin")
path+=("/usr/sbin")
path+=("$HOME/.local/bin")
path+=("$HOME/.scripts")
path+=("$HOME/Android/Sdk/platform-tools")
path+=("$HOME/.cargo/bin")
export PATH

export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
export ANDROID_HOME="$HOME/Android/Sdk/"

export EDITOR='vim'

# FZF options for previewing files and expanding commandis from history
export FZF_CTRL_T_OPTS="--preview 'preview-file {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

# Start FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# load keychain to manage SSH and GPG keys
if command -v keychain &>/dev/null; then
  eval `keychain --eval --agents ssh id_rsa`
fi

alias open="open_command"

# Kubectl version switch
function switch-kubectl() {
  if ! alias kubectl 2>/dev/null >/dev/null; then
    echo "Setting kubectl to version 1.6.0"
    alias kubectl='~/.local/bin/kubectl-1.6.0'
  else
    echo "Setting kubectl to default version"
    unalias kubectl
  fi
}

# Strongbox
alias strongbox=/opt/strongbox-cli/bin/strongbox

# added by travis gem
[ -f /home/nicolas/.travis/travis.sh ] && source /home/nicolas/.travis/travis.sh

# PyEnv stuff
export PATH="/home/nicolas/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
