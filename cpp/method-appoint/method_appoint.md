# 《C++元编程》第一节 方法指定

## 问题描述

现在设计一种情景。

我们某个项目中，需要适应多个不同的底层GUI库。
在 _显示_ 接口上，
有的库用的是show，
有的库用的是display。

为了调用的方便，
现在需要将接口统一。
所以需要实现一个adapter类，
来隐藏底层的实现细节。

为了简化问题，
现在将这个场景简化成以下形式：

现在有四个类，
`Worker_A`,
`Worker_B`,
`Worker_C`,
`Worker_D`。

其中，`Worker_A`和`Worker_B`只有一个 `show` 方法，
`Worker_C`和`Worker_D`只有一个 `display` 方法。

现在需要实现一个 `Adapter` 类，
将 _显示_ 接口统一成 `render`。

而且一个重要的限制，
不可以修改`Worker_A`,
`Worker_B`,
`Worker_C`,
`Worker_D`的源代码。

## 使用一个条件判断

第一个想法就是使用条件判断一下，
比如这样：

    enum{RENDER_BY_SHOW, RENDER_BY_DISPLAY};

    template<class Worker, int render_type>
    class Adapter1{
    public:
        void render(){
            switch(render_type){
            case RENDER_BY_SHOW:
                _worker->show();
                break;
            case RENDER_BY_DISPLAY:
                _worker->display();
                break;
            }
        }
    private:
        Worker* _worker;
    };

使用的时候，只需要这样：

    Adapter1<Worker_A, RENDER_BY_SHOW> a1;
    a1.render();

    Adapter1<Worker_C, RENDER_BY_DISPLAY> c1;
    c1.render();

但是这样是不行的！

因为根本编译不通过！

四个Worker类，要么只有`show`方法，要么只有`display`方法。
所以无论给`Adapter1`的第一个参数传哪个类型，


    _worker->show();

或者

    _worker->display();

这两个语句，
肯定会有一行报编译错误的。

因为编译器是不管条件判断的，
它要认真、仔细地编译每一个语句。

## 使用函数重载

不能在运行期判断类型，
必须在编译期来完成这个判断，
很自然地，
我们想到了函数重载。

我们可以做一个简单的约定，
比如，

* `char` 类型表示使用show方法
* `float` 类型表示使用display方法

那么，代码就变成了这个样子：

    template<class Worker, typename switcher>
    class Adapter2{
    public:
        void render(){
            render_dispatch(switcher());
        }
    private:
        void render_dispatch(char){
            _worker->show();
        }
        void render_dispatch(float){
            _worker->display();
        }

        Worker* _worker;
    };

然后调用的方式就变成了这个样子：

    Adapter2<Worker_A, char> a2;
    a2.render();

    Adapter2<Worker_C, float> c2;
    c2.render();

可是，
这样的写法看起来好奇怪，有木有！

代码的可读性是很重要的。

如果有人直接看调用的代码，
他肯定会要吐槽，
`char`和`float`到底表示的是神马呀！

## 将值转化为类型

我们希望的直观的调用方式应该是这个样子的：

    Adapter3<Worker_B, RENDER_BY_SHOW> b3;
    b3.render();

    Adapter3<Worker_D, RENDER_BY_DISPLAY> d3;
    d3.render();

但是，这无法直接使用函数重载的方案。
为什么？

因为，
`RENDER_BY_SHOW`和`RENDER_BY_DISPLAY`是 _值_ ，
而`char`和`float`是 _类型_ 。

函数重载只能用于 _类型_ ，
而不能用于 _值_ 。

我们需要将 _值_ 转化为 _类型_。

怎么做呢？（思考一下）

其实一个很简单的方法就可以做到。

    template<int from_value>
    class IntToType{
    public:
        enum{value=from_value};
    };

有了这个类，代码只需要稍加修改就可以了。

    template<class Worker, int render_type>
    class Adapter3{
    public:
        void render(){
            render_dispatch(IntToType<render_type>());
        }
    private:
        void render_dispatch(IntToType<RENDER_BY_SHOW>){
            _worker->show();
        }
        void render_dispatch(IntToType<RENDER_BY_DISPLAY>){
            _worker->display();
        }

        Worker* _worker;
    };

## 省略参数

每次都需要指定`render_type`，
这很麻烦。

而且如果不注意的话，
也很容易写错。

所以我们希望用一段代码来保存`Worker_X`类到`render_type`的对应关系，
这样每次只需要传一个`Worker_X`类，
就可以自动的查找到对应的`render_type`。

一种直接的方法是用函数来完成这个功能：

    int WorkerToRenderType(Worker_A){
        return RENDER_BY_SHOW;
    }

    int WorkerToRenderType(Worker_C){
        return RENDER_BY_DISPLAY;
    }

但是，
这种方法是不行的！

理由是：
函数的返回值是运行期才能确定的。

而刚才我们说过，
必须要在编译期就指定`render_type`。

所以，
有什么办法可以在编译期建立`Worker_X`类型到`render_type`的对应关系呢？
（思考一下）

模板的 _偏特化_ 可以帮助我们做到。

代码如下：

    template<class WorkerType>
    class WorkerToRenderType{
    };

    template<>
    class WorkerToRenderType<Worker_A>{
    public:
        enum{render_type = RENDER_BY_SHOW};
    };

    template<>
    class WorkerToRenderType<Worker_C>{
    public:
        enum{render_type = RENDER_BY_DISPLAY};
    };

有了对应关系，
我们就可以只提供一个`Worker_X`参数，
剩下的`render_type`通过查询对应关系来获得。

代码如下：

    template<class Worker>
    class Adapter4{
    public:
        void render(){
            render_dispatch(
                IntToType<
                    WorkerToRenderType<Worker>::render_type
                >()
            );
        }
    private:
        void render_dispatch(IntToType<RENDER_BY_SHOW>){
            _worker->show();
        }
        void render_dispatch(IntToType<RENDER_BY_DISPLAY>){
            _worker->display();
        }

        Worker* _worker;
    };

使用的时候只需要提供一个参数就可以了。

    Adapter4<Worker_A> a4;
    a4.render();

    Adapter4<Worker_B> b4;
    b4.render();

    Adapter4<Worker_C> c4;
    c4.render();

    Adapter4<Worker_D> d4;
    d4.render();

## 还有改进的余地

这个方案看起来已经很不错了。
但是对于那些 _精益求精_ 的人，
还是可以提出一些需要改进的地方。

### 1. 应付类膨胀

目前我们有四个`Worker`类，
所以提供了四个`WorkerToRenderType`的偏特化类。

如果有一天，
出现了第五个，第六个`Worker`类，
或者更多，
我们就需要在维护`WorkerToRenderType`上，
做很多事情。

而且一个重要的问题是，
`WorkerToRenderType`是用模板实现的，
所以它必须写在头文件里。
这可能会产生大量的编译依赖，
导致大面积的代码需要重新编译，
可能会消耗大量的编译时间。

这个问题，
有一种很tricky的解决办法，
以后的章节，
（如果我想得起来），
会讲到。

### 2. 提供工厂方法

将不同的`Worker`类作为参数传给`Adapter`，
就会得到 _完全不同_ 的类。

它们之间没有继承关系，
也没有共同的基类。

造成的结果就是，
我们没办法给这些类提供统一的工厂方法。

这个问题，
也有一种很tricky的解决办法，
以后的章节，
（如果我想得起来），
会讲到。

### 3. 编译依赖问题

我们的主应用程序，
可能只用到了`Worker`类中的一个。

但是为了编译整个程序，
我们需要依赖全部的`Worker`类。

这在很多情况下，
是不必要的，
甚至可能是无法实现的。
比如在Linux的X11环境下，
根本不可能依赖MFC库。

所以我们需要同时兼容各种不同的`Worker`类，
但是又要做到彼此隔离。

而且，
如果我们希望发布此程序的二进制版本，
并且能够适应不同环境，
就需要程序在运行时，
自动判断当前所处的环境。

这并不是完全不可能实现，
只是实现的方法很tricky。
不在本系列文章想介绍的范围之内。

## 全文完

本节的主要内容就是这些。

虽然目前还没有涉及到任何的元编程的东西，
但是本节提到的三个重要的技术，
是后面几节的基础。
