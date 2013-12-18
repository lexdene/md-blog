# 《C++元编程》第二节  编译期判断继承关系

## 问题描述

在C++中，随便给你两个class，
如何判断其中一个class是否继承自另一个class？（思考一下...）

## 函数重载

函数重载是C++中的一个很重要，也很有用的东西。
用好了，威力无穷；
用的不好，毁灭世界。

我们的思路是，
判断是否继承交给函数重载来判断。
让它返回不同的值。

    template<typename Base, typename Derived>
    class ConvertTester1{
    public:
        static bool is_derived(){
            is_derived_from(Derived());
        }
    private:
        static bool is_derived_from(Base){
            return true;
        }
        static bool is_derived_from(...){
            return false;
        }
    };

如果Derived继承自Base，
那么`is_derived_from(Derived())`
就会调用`static bool is_derived_from(Base)`函数。
否则就会调用`static bool is_derived_from(...)`函数。

三个点`...`是C语言中的一个不常用的语法（C++继承了C），
表示的意思是不定长的参数列表。
它接受所有类型和个数的参数。

## 编译期

不过上面的用法还有可以提高的地方。
比如说，能否在编译期来做这个判断？

将这个判断改到编译期有什么好处呢？
其实好处很多的！
我会在以后的几节给大家详细的讲解，
C++可以在编译期做很多神奇的事情。

那么如何实现在编译期来做这个事情呢？

C++在编译期的三大神器：

* 模板偏特化
* 函数重载
* sizeof

首先，模板偏特化肯定没什么疑问，它肯定是在编译期指定的。

函数重载，其实也是在编译期指定的。
不信？
如果将C++代码编译成汇编代码，
你就会发现，
哪个类型的参数调用哪个版本的函数，
在编译期就已经决定好了的。

最后，sizeof。
对于一些新手来说，
通常会对sizeof有些误解。
其实sizeof根本不是一个函数，
它只是一个运算符。
跟加减乘除大于小于什么的一样。
而且，它会在编译期直接对它求长的表达式做类型推导，
然后直接将推导出来的类型的长度写入编译出来的代码中。
也就是说，
它 _根本不会_ 执行它求长的表达式。
不信？
看下面的例子：

    #include<iostream>
    using namespace std;

    int main(){
        int i = 0;
        cout << sizeof(i++) << endl;
        cout << i << endl;

        return 0;
    }

第一行输出，基本上（在现在 _2013年_ 的主流的PC机上）会是4。
关键是第二行。

sizeof根本不会执行它求长的表达式，
所以i的值仍然是0。

本节中，
我们会用到函数重载和sizeof。

至于模板偏特化，
上一节就用到了，
以后也会经常用到的。

## 编译期判断

那么如何实现在编译期判断继承关系呢？

我们的思路是，

1. 利用函数重载，_继承_ 与 _不继承_ 返回不同的类型。
2. 利用sizeof，将不同的类型变成不同的长度。
3. 做一个相等判断，就可以知道它是 _继承_ 还是 _不继承_ 了。

首先，创造两个长度不同的类型：

    struct Small{
        char data[2];
    };
    struct Big{
        char data[4];
    };

其实这里写的2和4，
完全是我随便写的，
其实只要它们不相等就可以的。

然后是函数重载和相等判断：

    template<typename Base, typename Derived>
    class ConvertTester2{
    private:
        static Small test_derived(Base);
        static Big test_derived(...);
    public:
        enum{test =
            sizeof(
                test_derived(
                    Derived()
                )
            ) == sizeof(
                Small
            )
        };
    };

如果`Derived`继承自`Base`，
`test_derived(Derived())`就会调用`static Small test_derived(Base);`函数，
它的返回值类型就是`Small`，
那么`sizeof(Small) == sizeof(Small)`就会是`true`。

反之，就是`false`。

在这里，我们看到，
`test_derived`函数根本没有实现。
这就印证上我们上面所说的，
sizeof根本不会执行它求长的表达式。
也就是说`test_derived`根本没有被执行过，
所以`test_derived`只需要声明就可以，
根本不需要实现。

> 一个从来没有被执行过的函数，（大多数情况下）根本不需要写它的实现

## 还有问题？

费了这么半天劲，
终于把我们的解决方案改成了编译期判断。
那么它还有什么问题吗？

有的。

在 _设计模式_ 中，
有一种模式叫做 _单例模式_ 。
使用C++来实现 _单例模式_ 的时候，
为了保证实例的唯一，
通常要将单例类的构造函数写成private的。

这会对我们的代码造成什么影响？

在上面的解决方案中，我们使用`Derived()`来得到`Derived`类的一个实例，
如果`Derived`类的构造函数是private的，
那么`Derived()`这一行就会报告编译错误。

这给我们的解决方案提了一个难题：

有没有什么办法，
不通过构造函数就能够得到一个类的对象，
而且还能适应各种不同类型的类？

有的。

记得我们之前讲到，
sizeof根本不会执行它求长的表达式，
所以我们完全可以给它提供一个 _假_ 的对象，
只需要让sizeof完成类型推导就可以了。

比如，这样的一个函数：

    Derived make_derived();

而且，由于sizeof的特点，
这个函数根本不需要实现，
只需要一个声明就可以了。

完整代码如下：

    template<typename Base, typename Derived>
    class ConvertTester3{
    private:
        static Small test_derived(Base);
        static Big test_derived(...);
        static Derived make_derived();
    public:
        enum{test = sizeof(test_derived(make_derived())) == sizeof(Small)};
    };

## 全文完
