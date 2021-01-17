# 学习 Apple Script

先说我想实现一个什么功能:

在 osx 上的微信、QQ 之类的软件里面，
当我点击一个链接的时候，系统会打开我的默认浏览器，并跳转到这个链接。

但是我希望它不要打开浏览器，而是把链接复制到剪贴板。

我在网上搜索了好久，没有找到这样功能的 App ，可能是我的需求太奇葩了吧。

所以我打算自己写一个。

研究了一圈，我发现，使用 Apple Script 实现这个功能非常简单。

## 第一步

打开 osx 自带的 _脚本编辑器_ 程序，通常在 _启动台_ 里面仔细搜寻就可以找到它。

将以下代码粘贴进去:

    on open location this_URL
        set the clipboard to this_URL
    end open location

点击保存，
文件格式选择 _应用程序_ ，
路径选择 _Applications_ ，
名字随便起一个。

## 第二步

点击右上角 _显示包内容_ 按钮，
点击齿轮图标，
点击 _在访达中显示_ 。

## 第三步

使用你最喜欢的文本编辑器打开 `Info.plist` 文件，
在最外层的 `dict` 里面插入以下内容。

    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLName</key>
            <string>SysPref Handler</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>http</string>
            </array>
        </dict>
        <dict>
            <key>CFBundleURLName</key>
            <string>SysPref Handler</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>https</string>
            </array>
        </dict>
    </array>

保存退出。

## 第四步

执行一次刚刚创建的应用程序。

## 第五步

将刚刚创建的应用程序设为默认浏览器。
