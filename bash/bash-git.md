# bash提示符显示git仓库状态
将以下内容写到~/.bashrc的末尾

	PS1='\033[46m\033[31m\d 时间\t 当前目录\[\033[1;32m\][\w]$(__git_ps1 "(%s)")\[\033[0m\]\n\[\033[1;33m\]\u\[\033[1;35m\] \# -> \[\033[0m\] '
	export GIT_PS1_SHOWDIRTYSTATE=true
