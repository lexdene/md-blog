# 微信小程序 - 请求时自动在 title bar 显示 loading 图标

需求很简单, 每次做网络请求的时候, 在 title bar 上显示一个 loading 图标. 当网络请求完成的时候, 隐藏这个 loading 图标.

相关的微信小程序 api 有:

    wx.request()
    wx.showNavigationBarLoading()
    wx.hideNavigationBarLoading()

## 初步实现

假设 doulib 作为相关函数的 ns, 代码如下:

    doulib = {
        request: function(opts){
            wx.showNavigationBarLoading();

            origin_complete = opts.complete;
            opts.complete = function(res){
                wx.hideNavigationBarLoading();
                if(original_complete){
                    origin_complete(res);
                }
            };

            return wx.request(opts);
        }
    };


大致的思路是, 先在请求之前 showNavigationBarLoading().
然后用一个新的 complete callback 把传进来的 complete 包起来，并且加上一句 hideNavigationBarLoading().

小 tip:
> 如果调试的时候, 网络请求太快, 看不到 loading 的效果, 可以在模拟器里面把 network throttling 调成最慢, 体验一下网络卡哭了的情况

## 关于 Page 状态导致的 bug

如果你以为, 这么简单就实现需求了, 那真是 too young, sometimes naive.

微信小程序的官方文档上说:

> 对界面的设置如wx.setNavigationBarTitle请在onReady之后设置

实际应用中, 有的时候, 我们会在 onLoad 的时候就开始一个网络请求, 而此时, 当前界面还没有进入 onReady 的状态, 这会导致一个神奇的 bug. (这个 bug 就不具体描述了, 你自己试一下就知道了)

最简单的解决方案, 是在 onReady 的时候才开始网络请求. 然而, 如果页面比较复杂, 在一些性能很差的手机上, 从 onLoad 到 onReady 会经过比较长的时间.
如果能在 onLoad 的时候就开始请求数据, 那卡顿感会减少很多.

所以最完美的解决方案是, 在开始网络请求的时候, 在当前 Page 上标记一个 loading = true. 如果在 onReady 之前, 这个请求完成了, 把它 loading 改成 false, 就当什么也没发生过. 如果在 onReady 的时候请求还没完成, 再显示 loading 图标.

大致代码如下:

    doulib = {
        BasePage: (function(){
            var constructor = function(){
                this.status = 'init';
                this.loading = false;
            };
            constructor.prototype.onReady = function(){
                this.status = 'ready';

                if(this.loading){
                    wx.showNavigationBarLoading();
                }
            };
            constructor.prototype.request = function(opts){
                this.loading = true;

                if(this.status == 'ready'){
                    wx.showNavigationBarLoading();
                }

                var that = this;
                var origin_complete = opts.complete;
                opts.complete = function(res){
                    that.loading = false;
                    if(that.status == 'ready'){
                        wx.hideNavigationBarLoading();
                    }
                    if(original_complete){
                        origin_complete(res);
                    }
                };

                return wx.request(opts);
            };
            return constructor;
        })(),
    };

使用的时候需要:

1. 当前 Page 继承自 `doulib.BasePage`
2. 在 Page 内, 使用 `this.request()` 来发起网络请求

## 关于同时发起多个网络请求时的 loading 状态

有的时候, 业务比较复杂的情况下, 在 onLoad 的时候要同时发起多个网络请求. 如果直接使用上面的代码, 则会在第一个请求完成时结束 loading 状态. 这显然是个 bug.

在这种情况下, 需要我们在 request 函数里维护一个列表, 记录当前 Page 的所有的请求及每个请求的状态. 在当前 Page 的所有请求都完成时, 才结束 loading 状态.

这个逻辑比较简单, 我就不再啰嗦了. 相信你一定可以很轻易地实现它.

## 全文完
