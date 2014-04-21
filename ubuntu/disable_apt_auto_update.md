# 关闭ubuntu的apt自动更新

## 起因

有的时候，在ubuntu里执行

    sudo apt-get update

的时候，会报错误：

    E: 无法获得锁 /var/lib/apt/lists/lock - open (11: 资源暂时不可用)
    E: 无法对目录 /var/lib/apt/lists/ 加锁

## 搜寻

我猜测有后台进程在执行apt-get，所以查看了一下:

    ps aux | grep apt

结果发现了这一行:

    /bin/sh /etc/cron.daily/apt

打开看看这个文件，在文件的开头发现了这几句:

    #  APT::Periodic::Enable "1";
    #  - Enable the update/upgrade script (0=disable)

    #  APT::Periodic::Update-Package-Lists "0";
    #  - Do "apt-get update" automatically every n-days (0=disable)

看来自动更新是可以配置的。

## 解决

打开配置文件:

    sudo emacs /etc/apt/apt.conf.d/10periodic

在开头加入一行:

    APT::Periodic::Enable "0";

或者把第一行改成:

    APT::Periodic::Update-Package-Lists "0";
