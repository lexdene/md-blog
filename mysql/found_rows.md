# MySQL中用found_rows高效处理分页

## 查询当前页的内容

在web开发中，经常需要用到分页功能。

比如，当前是第5页，每页显示10条内容，SQL语句就可能是这样的:

    select * from topic limit 50, 10;

这条语句没什么问题，不是本文想讲的东西。

## 查询一共有几页

通常，在用户友好的网页上，
除了显示当前页的内容，
还会显示一共有几页。

为了计算一共有几页，
我们得先知道数据库中一共有多少条。

通常大家用这样的SQL语句来查询：

    select count(*) from topic;

呃……这也不是本文想讲的东西。

## 复杂的查询条件

比如，用户想搜索标题包含 _elephant_ 的文章，
那么查询当前页的内容的SQL语句就变成了这样：

    select * from topic where topic.title LIKE '%elephant%' limit 50, 10;

查询一共有几页的时候，当然也得包括这个查询条件。

    select count(*) from topic where topic.title LIKE '%elephant%';

## 存在的问题
如果搜索条件变得复杂，
这些SQL语句中就存在大量的重复的代码。
这不是好事情。

虽然有些编程框架（Python / C++）能够自动地为我们处理这些事情，
但是仍然是靠客户端语言来处理的。

有没有什么MySQL本身的提供的支持？

## FOUND_ROWS函数
看如下两条SQL语句：

    select SQL_CALC_FOUND_ROWS * from topic where topic.title LIKE '%elephant%' limit 50, 10;
    select FOUND_ROWS();

第一条语句，在select后面加上了 `SQL_CALC_FOUND_ROWS` 选项。
注意： `SQL_CALC_FOUND_ROWS` 与 \* 之间没有逗号。

`SQL_CALC_FOUND_ROWS` 选项对第一条语句的结果没有任何影响，
它仍然正常返回我们需要的内容。

第二条语句，直接调用FOUND_ROWS函数。

作用是，
它能够自动地计算出，
where等操作后，
limit操作前的行的数目。

好处也很明显，
计算总条目的时候，
事实上包含了where之后的条件，
但是并不需要重复地写where子句。
