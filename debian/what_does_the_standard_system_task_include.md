# 安装debian时的"Standard system utilities"都包括哪些软件包?

在安装debian的时候，
最后一步有个选择安装哪些软件包的选项，
其中有一个选项叫"Standard system utilities"。

看见有人问这个选项都包括哪些软件包，
以及不装这些的话会不会有什么严重的后果。

今天我就来回来一下。

## debian官方wiki

https://wiki.debian.org/tasksel

## 本机执行一下

    $ tasksel --task-packages standard
    whois
    python2.6-minimal
    mlocate
    m4
    mime-support
    file
    exim4-base
    w3m
    libswitch-perl
    less
    dnsutils
    bsd-mailx
    apt-listchanges
    rpcbind
    doc-debian
    procmail
    dc
    perl-modules
    python-support
    bind9-host
    liblockfile-bin
    db5.1-util
    mutt
    nfs-common
    exim4-config
    reportbug
    texinfo
    python2.7
    time
    exim4
    python-minimal
    debian-faq
    krb5-locales
    libclass-isa-perl
    ftp
    lsof
    bash-completion
    at
    bc
    python-reportbug
    python
    perl
    exim4-daemon-light
    ncurses-term
    bzip2
    telnet
    python-apt

## 我的观点

其中有些软件包还挺有用的，
但是大多数我感觉都用不着。

所以我一般选择不安装"Standard system utilities"，
然后手动安装我自己需要的软件包。

## 全文完
