# MySQL的order by时区分大小写

MySQL默认的order by是不区分大小写的。
如果我们希望使用区分大小写的order by，
该怎么办呢？

## 先看一个例子。

表结构：

    create table test_collate(
       `id` int NOT NULL AUTO_INCREMENT,
       `text` varchar(40) NOT NULL,
       PRIMARY KEY (`id`)
    )ENGINE=MyISAM DEFAULT CHARSET=utf8;

插入数据：

    insert into test_collate(`text`) values('aaa'),('bbb'),('AAA'),('BBB');

现在，如果我们按照text排序：

    select * from test_collate order by text;

结果：

    +----+------+
    | id | text |
    +----+------+
    |  1 | aaa  |
    |  3 | AAA  |
    |  2 | bbb  |
    |  4 | BBB  |
    +----+------+

结果表明，大写的AAA和小写的aaa被认为是一样的，
都排在BBB和bbb前面。

## 为什么呢？

这里涉及到一个重要的概念，叫collate。
collate是一个与charset有关的概念，
它会影响到很多事情，
其中就包括排序的规则。

在《MySQL必知必会》中对collate有过详细的介绍，
我们就不在这里去介绍它了。

## 如何解决

解决方案有两个：

1. 将test_collate表的collate改成case sensitive的
2. 使用case sensitive的collate进行order by

这里，我们不希望改变表结构，
只是临时地order by一下，
因为使用方案2。

代码如下：

    select * from test_collate order by text collate utf8_bin;

结果如下：

    +----+------+
    | id | text |
    +----+------+
    |  3 | AAA  |
    |  4 | BBB  |
    |  1 | aaa  |
    |  2 | bbb  |
    +----+------+
