# emacs中使用auto-complete

## 环境
* ubuntu操作系统。
* Ubuntu 12.04.2 LTS
* emacs23-nox

## 第一步，安装

	sudo apt-get install auto-complete-el

## 第二步，加载之
在~/.emacs末尾加入以下内容：

	; auto complete
	(require 'auto-complete-config)
	(ac-config-default)

## 第三步，启动emacs，自己试试吧。

## 附录：
* 用户手册：[manual]

[manual]: http://cx4a.org/software/auto-complete/manual.html '用户手册'
