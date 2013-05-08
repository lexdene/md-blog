# bash提示符显示git仓库状态
将以下内容写到~/.bashrc的末尾

	PS1='\033[46m\033[31m\d 时间\t 当前目录\[\033[1;32m\][\w]\n$(__git_ps1 "(%s)")\[\033[0m\]\n\[\033[1;33m\]\u\[\033[1;35m\] \# -> \[\033[0m\] '
	export GIT_PS1_SHOWDIRTYSTATE=true
	export GIT_PS1_SHOWUNTRACKEDFILES=true
	export GIT_PS1_SHOWSTASHSTATE=true
	export GIT_PS1_SHOWUPSTREAM="auto verbose"

这样配置以后，
基本上可以满足我大多数情况下的需求。

有更高需求的同学，
可以看一下powerline-shell，
链接地址：

	https://github.com/milkbikis/powerline-shell

## 再提供一些其它的配色方案
### 方案一

	PS1='\033[1;35m\d \t [\H \w]\[\033[0m\]
	\[\033[1;32m\]$? $(__git_ps1 "(%s)")\[\033[0m\]
	\[\033[1;33m\]\u\[\033[1;35m\] \# -> \[\033[0m\] '

### 方案二

	PS1='\033[1;35m\d \t [\u@\H:\w]\[\033[0m\]
	\[\033[1;32m\]$? $(__git_ps1 "(%s)")\[\033[0m\]
	\[\033[1;33m\]\# -> \[\033[0m\] '
