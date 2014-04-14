# git diff 显示创建分支后的修改

从`develop`分支创建一个`feature`分支，
经历了若干个`commit`之后，
我想知道这个分支从创建到现在都发生了哪些修改。

直接`git diff develop`是不行的，
因为`develop`可能在这段时间也增加了好多内容。
我不想看`develop`上增加的内容，
只想看`feature`分支上发生的修改。

难道要去记住创建`feature`分支时的commit编号吗？

不！
git提供了更简单的方法。

## git diff 中2个点和3个点的区别

比如`A`和`B`是两个分支名，那么下面的命令

    git diff A..B

可以用来比较两个分支的差异。

这里我们用2个点来分隔分支名。

如果你详细地看git diff的文档的话,

    git help diff

你会发现一种3个点的用法：

    git diff A...B

那么3个点是什么意思呢？

答：
它是用来比较`A和B的公共祖先`与`B`的差异。
它相当于下面的命令：

    git diff $(git-merge-base A B) B

## 回到我们最初的问题

`develop`分支和`feature`的公共祖先，
事实上就是创建`feature`分支时的commit。

所以我们可以通过下面的命令:

    git diff develop...feature

来查看创建`feature`分支以来的修改。

甚至地，
如果我们的当前分支就是`feature`，
我们可以省略第二个分支名，
简写成:

    git diff develop...
