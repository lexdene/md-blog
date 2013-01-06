#【apache+cgi+python】cgi接口浅析

虽然现在开发web用的都是一些成熟的框架，
使我们可以不用关心底层的接口逻辑，
但是多了解一些底层的知识对我们也是有帮助的。

虽然在效率上cgi接口远不如其它几个接口，
但是它足够简单，
非常适合新手入门。

本文使用python，curl，
在ubuntu + apache环境下为大家展示cgi接口的基本原理。

本人小菜一枚，
文中错误在所难免，
希望大家能够不吝赐教。

## 首先、配置apache、htaccess
网站根目录为/var/www，
我们放试验脚本的目录为/var/www/python-cgi。

apache的配置

	$ gedit /etc/apache2/sites-available/default

	<VirtualHost *:80>
		DocumentRoot /var/www
		<Directory "/var/www/python-cgi/">
			Options +ExecCGI +FollowSymLinks
			AllowOverride All
			Order allow,deny
			Allow from all
		</Directory>
	</VirtualHost>

在/var/www/python-cgi目录下放个.htaccess文件，内容为

	AddHandler cgi-script .py
	DirectoryIndex py-cgi-index.py
	AddType text/html .py
	<IfModule mod_rewrite.c>
		RewriteEngine on
		RewriteCond %{REQUEST_FILENAME} !-f
		RewriteCond %{REQUEST_FILENAME} !-d
		RewriteRule ^(.*)$ py-cgi-index.py/$1 [L]
	</IfModule>

在/var/www/python-cgi目录下放个py-cgi-index.py文件，
然后添加可执行权限。

	$ chmod a+x py-cgi-index.py

环境配置就完成了。

## 一、cgi的hello world
cgi的通信依靠stdout与浏览器通信。
所以简单地在py-cgi-index.py里面写：

	#!/usr/bin/env python
	print 'hello world'

这样写是不对的。
cgi接口规定，cgi脚本输出的开头应该是http header。
而hello world这种字符无法被识别为任何有效的http header，
所以如果访问http://localhost/python-cgi，会返回500错误。

解决办法有两个：

1、写上http header。
header与body之间必须有一个空行，以识别前面的是header，后面的是body。
代码改成：

	#!/usr/bin/env python
	print 'Content-Type: text/html\n\nhello world'

2、空白http header。
不写http header的情况下，apache会自动补上header。
代码改成：

	#!/usr/bin/env python
	print '\nhello world'

关于header，我还要再说一个问题。
cgi脚本的stdout首先要交给apache，
apache会对stdout进行一些处理。
如果使用curl -i查看返回的http header，
会发现，header部分被补全了：

	HTTP/1.1 200 OK
	Date: Sun, 06 Jan 2013 02:49:21 GMT
	Server: Apache/2.2.22 (Ubuntu)
	Vary: Accept-Encoding
	Content-Length: 20
	Content-Type: text/html

## 二、服务器参数
在php中，有一个重要的全局变量叫$_SERVER，它包含了服务器的一些参数。
那么在我们的cgi脚本中，如何获得这些参数呢？
答案是环境变量。
代码改成：

	#!/usr/bin/env python
	import os
	print 'Content-Type: text/html\n\n'
	for i in os.environ:
		print '%s => %s'%(i,os.environ[i])
就可以看到，os.environ中有我们需要的很多参数，
包括：

	REDIRECT_QUERY_STRING
	REDIRECT_STATUS
	SERVER_SOFTWARE
	SCRIPT_NAME
	SERVER_SIGNATURE
	REQUEST_METHOD
	PATH_INFO
	REDIRECT_URL
	SERVER_PROTOCOL
	QUERY_STRING
	PATH
	HTTP_USER_AGENT
	SERVER_NAME
	REMOTE_ADDR
	PATH_TRANSLATED
	SERVER_PORT
	SERVER_ADDR
	DOCUMENT_ROOT
	SCRIPT_FILENAME
	SERVER_ADMIN
	HTTP_HOST
	REQUEST_URI
	HTTP_ACCEPT
	GATEWAY_INTERFACE
	REMOTE_PORT

## 三、get参数
最常用的向服务器提交参数的方法就是get。
我们这里用curl来模拟：

	$ curl -i http://localhost/python-cgi/xxx?aaa=bbb\&ccc=ddd
然后可以看到：

	os.environ['QUERY_STRING']变成了aaa=bbb&ccc=ddd
这个就是get参数。
不过，
在这里，
我们需要手工地按照'&'来切分各个query段。

## 四、post参数
除了get以外，
用户名、密码、文件上传等通常都是使用post来提交。
那么cgi脚本中如何获得post的数据呢？
答案是stdin。
代码改成：

	#!/usr/bin/env python
	print 'Content-Type: text/html\n\n'
	while True:
		i = raw_input()
		if i is None:
			break
		print i

1、简单的post参数：

	$ curl -i --data "ggg=hhh" --data "iii=jjj" http://localhost/python-cgi/xxx?aaa=bbb\&ccc=ddd\&eee=fff
它会输出：

	ggg=hhh&iii=jjj
之后我们需要手动地按照&分隔各个段。

2、文件上传：

	$ curl -i --form upload=@filepath --form name=elephant http://localhost/python-cgi/xxx?aaa=bbb\&ccc=ddd\&eee=fff
它会输出：

	------------------------------11c41e187464
	Content-Disposition: form-data; name="upload"; filename="filepath"
	Content-Type: application/octet-stream
	
	中间的是文件内容
	
	------------------------------11c41e187464
	Content-Disposition: form-data; name="name"
	
	elephant
	------------------------------11c41e187464--
并且此时，os.environ中有一个重要的值：

	CONTENT_TYPE => multipart/form-data; boundary=----------------------------11c41e187464
boundary后面的是分隔线。
之后需要人为地按照这个分隔线来区分各个段的内容，
并且还要解析Content-Disposition的内容。

## 五、日志输出
apache有日志功能，我们的cgi脚本能输出到apache的日志中？
答案是肯定的，方法是stderr。
代码改成：

	#!/usr/bin/env python
	import os
	print 'Content-Type: text/html\n\nHello world'
	os.stderr.write('this is log')
在访问之后，
就可以去apache的日志中找输出的内容了。

## 六、总结
cgi的接口如此的简单，
使用的仅仅是stdin、stdout、stderr、环境变量四个最常用的进程间交换数据的方式。
而且几乎所有语言都能够处理这四项内容。
剩下的事情，

* http协议规定的东西，
例如在http header添加cookie段可以在浏览器端生成cookie。
* 编程语言自己来处理的事情，
包括数据库、session、文件读写等。

有空也用c语言写一个吧。

全文完。
