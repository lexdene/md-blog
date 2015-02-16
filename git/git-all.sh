#!/bin/bash
# git批量操作,一次性对一个目录下的所有git仓库执行命令
#
# 原理就是通过find查找所有的.git目录
# 然后cd到那个目录下，执行相同的命令

APPNAME='git all'
VERSION=1.1

#帮助处理
if [ "$#" == 0 ]
 then
	echo "usage: $APPNAME <command>"
	exit 1
fi

#版本处理
if [ "-v" == "$1" ]
 then
	echo $APPNAME $VERSION
exit 1
fi

for path in `find . -name .git`
 do
	# 为了兼容bash < 4.2
	((len=${#path}-4))
	subpath=${path:0:$len}

	pushd . > /dev/null
	cd $subpath
	echo -e "\033[32;40m $subpath >> git $@ \033[0m"
	git $@
	popd > /dev/null
done
