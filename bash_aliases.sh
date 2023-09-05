alias vpn="sudo openconnect usa.sv333.me"

# show this file for help
alias helpias="cat ~/configs/bash/bash_aliases.sh | less"

# bash commands
alias rbash="source ~/.bashrc"

#edit imoprtant files
alias edbash="vim ~/.bashrc"
alias aliases="vim ~/configs/bash/bash_aliases.sh"


# basic commands
# system commands
alias sus="systemctl suspend"

# vim
alias vi="nvim"
alias vim ="nvim"
alias vimconf="vi ~/configs/nvim/init.lua"

# important folders
# alias code="cd ~/code"
alias shells="cd ~/shells"
alias gocode="cd ~/go/src/github.com/miradii"
alias books="cd ~/Desktop/books"

# emacs related aliases
alias ed="emacs --daemon"
alias ec="emacsclient -c" # open a new emacs frame
alias et="emacsclient -t" # in terminal
alias kem="emacsclient -e '(kill-emacs)'"

# configs
alias bashconf="vi ~/configs/bash/"
alias alconf="vi ~/.config/alacritty/alacritty.yml"


# vim

# tor commands
alias torr="systemctl restart tor"
alias tors="systemctl status tor"

# git commands 
alias gits="git status"
alias gad="git add ."
alias gc="git commit -m"

# tmux commands
alias tn="tmux new -s" # start a named session useage: tn <session-name>
alias tls="tmux ls" # show all sessions
alias tat="tmux at" # attacth to last session
alias tan="tmux at -t" # attacth to named session usage: tan <session-name>


# ---- nix related commands
alias webshell="nix-shell ~/shells/web_shell.nix "
alias pyshell="nix-shell ~/shells/py_shell.nix "

# golang
alias air="~/go/bin/air"
