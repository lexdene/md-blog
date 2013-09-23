PS1='\033[1;35m[\u@\H:\w]\[\033[0m\]
\033[1;35m$(date "+%Y-%m-%d %A %H:%M:%S")\[\033[1;32m\]$(__git_ps1)\[\033[0m\]
\[\033[1;33m\]\# -> \[\033[0m\] '
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUPSTREAM="auto verbose"
