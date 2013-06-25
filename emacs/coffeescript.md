# 在emacs中安装配置CoffeeScript环境

最近用CoffeeScript开发前端，  
CoffeeScript可以编译成优质的js代码。  
但是在emacs中编写CoffeeScript，  
既没有缩进，也没有高亮，这很难受。  
在网上搜索了半天，
找到了一个开源的coffee-mode。  
地址： https://github.com/defunkt/coffee-mode

## 安装

    cd ~/.emacs.d
    git clone git://github.com/defunkt/coffee-mode.git

## 配置

在~/.emacs中添加以下内容：

    ; coffee-mode
    (add-to-list 'load-path "~/.emacs.d/coffee-mode")
    (require 'coffee-mode)

## 参考资料

1. http://ozmm.org/posts/coffee_mode.html
2. https://github.com/defunkt/coffee-mode
