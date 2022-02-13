# ubuntu 上交换某些键位

我自己的一个习惯是把 Ctrl 键和 Caplock 键交换位置,
同时把 Alt 键和 Win 键交换位置.

之前一直使用 [GNOME Tweaks] 来完成此类操作,
后来觉得每次还要启动一个 app, 就觉得好麻烦.

后来看了一下 [GNOME Tweaks] 的源代码, 发现可以直接调用 gsettings 命令.

交换 Ctrl 键和 Caplock 键:

    gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:swapcaps']"

交换 Alt 键和 Win 键:

    gsettings set org.gnome.desktop.input-sources xkb-options "['altwin:swap_alt_win']"

同时交换两者:

    gsettings set org.gnome.desktop.input-sources xkb-options "['altwin:swap_alt_win', 'ctrl:swapcaps']"

我还写了一个简单的命令, 方便我随时开启/关闭交换键位.

    swap-keys() {
        case "$1" in
            "enable")
                value="['altwin:swap_alt_win', 'ctrl:swapcaps']"
                ;;
            "disable")
                value="[]"
                ;;
            *)
                echo "invalid arg" $1
                return 1
                ;;
        esac
        gsettings set org.gnome.desktop.input-sources xkb-options "$value"
    }

[GNOME Tweaks]: https://wiki.gnome.org/Apps/Tweaks
