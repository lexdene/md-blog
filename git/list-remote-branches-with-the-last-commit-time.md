# 列出所有远程分支及最后commit时间并按时间排序

命令

    for branch in `git branch -r | grep -v HEAD`;do echo -e `git show --format="%ci %cr" $branch | head -n 1` \\t$branch; done | sort -r

运行结果

    2012-02-12 03:20:24 -0800 9 hours ago   origin/master
    2012-02-10 10:34:35 -0800 2 days ago  origin/3-2-stable
    2012-01-31 09:56:12 -0800 12 days ago   origin/3-1-stable
    2012-01-24 11:18:06 -0800 3 weeks ago   origin/3-0-stable
    2011-12-31 05:09:14 -0800 6 weeks ago   origin/2-3-stable
    2011-11-25 09:49:54 +0000 3 months ago  origin/serializers
    2011-06-16 12:08:26 -0700 8 months ago  origin/compressor
    2011-05-24 16:03:41 -0700 9 months ago  origin/sass-cleanup
    2011-01-17 14:14:24 +1300 1 year, 1 month ago   origin/2-1-stable
    2011-01-17 14:13:56 +1300 1 year, 1 month ago   origin/2-2-stable
    2010-08-17 17:11:17 -0700 1 year, 6 months ago  origin/deps_refactor
    2010-05-16 22:23:44 +0200 1 year, 9 months ago  origin/encoding
    2009-09-10 17:41:18 -0700 2 years, 5 months ago     origin/2-0-stable
    2008-02-19 02:09:55 +0000 4 years ago       origin/1-2-stable
