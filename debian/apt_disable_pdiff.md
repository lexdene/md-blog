# 如何在debian系统上禁用apt的pdiff更新机制

## 临时禁用方法:

    apt-get update -o Acquire::Pdiffs=false

## 永久禁用方法:

将下面这句话加到/etc/apt/apt.conf文件中。

    Acquire::PDiffs "false";
