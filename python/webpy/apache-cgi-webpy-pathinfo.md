# apache + cgi + web.py 时遇见的pathinfo问题

首先，我想把web.py放在一个子目录下，
因为其它目录还有其它的文件。

网站根目录为

	/var/www
web.py的目录为

	/var/www/webpy
## apache的配置
	
	gedit /etc/apache2/sites-available/default

	<VirtualHost *:80>
		DocumentRoot /var/www
		<Directory "/var/www/webpy/">
			Options +ExecCGI +FollowSymLinks
			AllowOverride All
			Order allow,deny
			Allow from all
		</Directory>
	</VirtualHost>

## .htaccess的配置

	AddHandler cgi-script .py
	DirectoryIndex py-cgi-index.py
	AddType text/html .py
	<IfModule mod_rewrite.c>
		RewriteEngine on
		RewriteCond %{REQUEST_FILENAME} !-f
		RewriteCond %{REQUEST_FILENAME} !-d
		RewriteRule ^(.*)$ py-cgi-index.py/$1 [L]
	</IfModule>

## py-cgi-index.py的代码
	#!/usr/bin/env python

	import sys, os
	abspath = os.path.dirname(__file__)
	sys.path.append(abspath)
	os.chdir(abspath)

	import web

	class Hello:
		def GET(self,path=''):
			return path

	if __name__ == "__main__":
		if os.environ.has_key('PATH_INFO'):
			urls = (
				'/(.*)', 'Hello'
			)
		else:
			urls = (
				'/.*', 'Hello'
			)
		application = web.application(urls, locals())
	
		application.run()

## 遇见的问题

### urls的配置
我之前的写法是:

	urls = (
		'/(.*)', 'Hello'
	)
这样写，如果访问的是:

	http://localhost/webpy/xxx
它会正常的输出:

	xxx
这说明RewriteRule正常的工作了。
但是如果访问

	http://localhost/webpy/
它会报告异常，意思是urls中没有匹配的路由规则。
搜索了一圈，发现其实这个时候RewriteRule并没有工作，
而是DirectoryIndex在起作用。

后来，我看了一些开源的php框架的源代码，
发现想知道RewriteRule有没有工作，可以通过环境变量中是否有'PATH_INFO'来判断。
最终变成了现在的代码。
