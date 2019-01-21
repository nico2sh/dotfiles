set -gx PATH /sbin $PATH 
set -gx PATH /usr/sbin $PATH 
set -gx PATH /home/nicolas/.local/bin $PATH 
set -gx PATH /home/nicolas/.scripts $PATH 
set -gx PATH /home/nicolas/Android/Sdk/platform-tools $PATH 
set -gx PATH /home/nicolas/.cargo/bin $PATH 
set -gx PATH /home/nicolas/.rvm/bin $PATH 

set -x JAVA_HOME (readlink -f /usr/bin/java | sed "s:bin/java::")

set -x FZF_CTRL_T_OPTS "--preview 'preview-file {}'" 
set -x FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

alias open="open_command"
alias strongbox="/opt/strongbox-cli/bin/strongbox"

set -x PATH "/home/nicolas/.pyenv/bin" $PATH
status --is-interactive; and . (pyenv init -|psub)
status --is-interactive; and . (pyenv virtualenv-init -|psub)

