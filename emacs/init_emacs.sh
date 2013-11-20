cd ~/.emacs.d

if ! [ -d coffee-mode ];then
    git clone https://github.com/lexdene/coffee-mode.git
fi

if ! [ -f vline.el ];then
    wget http://www.emacswiki.org/emacs/download/vline.el
fi

if ! [ -d compile-make ];then
    git clone https://github.com/lexdene/compile-make.git
fi
