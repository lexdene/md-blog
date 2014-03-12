# 使用css实现自动计算段落编号

在写文档的时候，
我们通常会把内容分成若干个段落。
每个段落都有一个标题。

而且我们会把段落分成若干个级别，
然后使用h1/h2/h3来做各个级别的标题。

有的时候呢，
为了理清段落之间的关系，
我们会给各个标题前加上编号。

比如：

    <h1>1. 编程语言</h1>

    <h2>1.1 C++</h2>
    <h2>1.2 Python</h2>

手动维护编号实在是一件很闹心的事情，
如果位置靠前的某个段落被删除了，
那么几乎每个段落的编号都要手动修改一下。

我们可以使用js脚本来计算每个段落的编号，
然后自动添加上去。
这样简单的代码，我相信你一定可以写出来。

不过今天我们要讲如何用css来实现这样的功能。

首先，css中的`counter-reset`可以创建一个计数器。
`counter-increment`可以将计数器加1。

然后，只需要用`counter`获取计数器的值，
把它填写在`content`中就行啦！

直接上代码：

    body {
        counter-reset: chapter;
    }

    h1 {
        counter-reset: section;
    }
    h1:before {
        counter-increment: chapter;
        content: counter(chapter) ". ";
    }

    h2 {
        counter-reset: subsection;
    }
    h2:before {
        counter-increment: section;
        content: counter(chapter) "." counter(section) " ";
    }

    h3:before {
        counter-increment: subsection;
        content: counter(chapter) "." counter(section) "." counter(subsection) " ";
    }

完整代码可以参见[demo](demo.html)
