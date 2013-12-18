# 《C++元编程》第三节  编译期断言

## 问题描述

断言`assert`是开发中很有用的工具。
通常我们使用的是 _执行期断言_ ，
它能够在执行期检查运行结果是否与预期的结果一致。

但是，
如果能把断言放在编译期，
就可以更早地发现可能隐藏的问题。

## 需求分析

普通的 _执行期断言_ ，
通常都接受一个bool类型的参数。
如果它为true，
就什么也不发生。
否则就报告错误，
立即结束程序。

我们的编译期断言，
也按照这个思路来做。

## 如何实现

上一节我们讲过，
编译期三大神器。

这一节我们将会用到其中的模板偏特化。

看下面的代码：

    template<bool> struct assert0;
    template<> struct assert0<true>{};

    int main(){
        assert0<true> _a;
        assert0<false> _b;

        return 0;
    }

那么`assert0`就是一个简单的编译期断言。

如果给`assert0`传一个`true`，
那么什么也不会发生。
如果传一个`false`，
编译期就会报错。
因为根本不存在值为`false`的偏特化版本。

## 编译期判断继承关系

上一节我们讲判断两个类的继承关系的时候，
费了好半天劲，
把判断改成了编译期做的事情。

这样改有什么意义呢？

`assert0`的参数必须是一个编译期确定的值，
所以如果我们想在编译期断言两个类的继承关系，
就必须在编译期判断继承关系。
（这句话好绕，不过我觉得你应该能懂我想说什么。）

结合上一节的内容，
在编译期断言两个类的继承关系：

    int main(){
        assert0<is_derived_from(BarBase, BarDerived)> _a;
        assert0<is_derived_from(BarBase, Foo)> _b;

        return 0;
    }

`BarDerived`继承自`BarBase`，
所以第一句什么也不会发生。

`Foo`和`BarBase`没有继承关系，
所以第二句会报告编译错误。

## 错误信息

刚才说，
没有继承关系的时候，
会报告编译错误。

可是报告出来的编译错误是什么样的呢？

    错误： 聚合‘assert0<false> _b’类型不完全，无法被定义

这尼马是什么意思啊！
这错误信息能体现出神马断言啊！

有没有办法改进一下这个错误信息呢？

有一些很tricky的方法。
比如这样：

    template<bool> struct assert1;
    template<> struct assert1<true>{
        assert1(...);
    };
    template<> struct assert1<false>{};

    #define assert2(expr, msg) { \
        class Error_##msg{}; \
        assert1<(expr)> _noname = Error_##msg();    \
    }

    int main(){
        assert2(
            is_derived_from(BarBase, BarDerived),
            Is_Not_Derived
        );
        assert2(
            is_derived_from(BarBase, Foo),
            Is_Not_Derived
        );

        return 0;
    }

它报告的编译错误是：

    请求从`Error_Is_Not_Derived`转换到非标量类型`assert1<false>`

虽然也看起来怪怪的，
但是至少有`Error_Is_Not_Derived`，
心理安慰了很多。

那么这段代码是什么意思呢？

首先看`struct assert1<true>`，
它定义了一个构造函数，
接受任意类型的参数。
（上一节我们讲过三个点的意思）
这样，
任何类型的对象都可以通过 _隐式类型转化_ 变成一个`struct assert1<true>`。

但是`struct assert1<false>`则没有这样的构造函数，
所以它不接受奇怪的类型向它的类型转化。

在`assert2`这个宏里，
我们又定义了一个奇怪的class，
叫`Error_##msg`，
`##`就是把`Error_`和`msg`做简单的字符串连接。

为了保证连接之后是一个正确的类名，
msg只能由_字母_ , _数字_ , _下划线_ 组成。

再之后，
将一个`Error_##msg`的对象转化成了一个`assert1<(expr)>`对象。

如果`expr`为true，
`struct assert1<true>`接受任何类型向它的类型转化，
所以什么也不会发生。
但是如果`expr`为false，
就会出现编译错误。

## 全文完
