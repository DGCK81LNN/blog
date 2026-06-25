---
date: 2026-06-26T01:29:46+08:00
tags: 信息技术杂项
---

# MediaWiki迁移到宝塔Linux面板小踩坑

最近我把我的“真魂站”网站从 iFastNet 的 cPanel 托管迁到了阿里云的 VPS，我用的是阿里云现成的宝塔面板镜像，但是在迁移过程中，网站上的 MediaWiki 软件出了两个意外状况：`fileinfo` 无法安装、SQLite 版本过低。这里我想简单分享一下我的解决方法。

我使用了 Apache + PHP 8.3，由于维基体量小，没有使用 MySQL 数据库，而是使用 SQLite 代替。MediaWiki 提示缺少 PHP 扩展 `mbstring` 和 `fileinfo`，我原本以为这很好解决，从宝塔面板的软件管理给 PHP 添加所需的扩展即可；但在安装 `fileinfo` 后依旧提示缺少 `fileinfo`，检查安装日志发现是服务器内存不足导致编译失败：


<pre markdown='span'>
检测到当前空闲内存为375MB 安装fileinfo至少需要1000MB空闲才可以安装
请尝试在面板首页中释放内存后再尝试安装
如内存仍不足，可执行以下命令后尝试安装，将会跳过内存验证，强制安装
命令：`touch /www/server/panel/install/u_fileinfo.pl`{: .highlight.language-bash}

\.\.\.\.\.\.

`cc -I. -I/www/server/php/83/src/ext/fileinfo -I/www/server/php/83/src/ext/fileinfo/include -I/www/server/php/83/src/ext/fileinfo/> main -I/www/server/php/83/src/ext/fileinfo -I/www/server/php/83/include/php -I/www/server/php/83/include/php/main -I/www/server/> php/83/include/php/TSRM -I/www/server/php/83/include/php/Zend -I/www/server/php/83/include/php/ext -I/www/server/php/83/include/> php/ext/date/lib -DHAVE_CONFIG_H -std=c99 -g -O2 -D_GNU_SOURCE -I/www/server/php/83/src/ext/fileinfo/libmagic > -DZEND_COMPILE_DL_EXT=1 -c /www/server/php/83/src/ext/fileinfo/libmagic/apprentice.c -MMD -MF libmagic/apprentice.dep -MT > libmagic/apprentice.lo -fPIC -DPIC -o libmagic/.libs/apprentice.o`{: .highlight.language-bash}
cc: fatal error: Killed signal terminated program cc1
compilation terminated.
make: *** [Makefile:220: libmagic/apprentice.lo] Error 1
</pre>

我的 VPS 运行内存只有 1GiB，网上资料都建议临时增加 Swapfile 交换空间来避免编译器编译 fileinfo 时内存溢出，例如：

~~~bash
dd if=/dev/zero of=/swapfile bs=1M count=1024
mkswap /swapfile
swapon /swapfile
make -j1 && make install
~~~

但无论我尝试怎样的配置，还是无法成功编译，交换空间似乎并没有被使用多少。

重新仔细查找资料，发现 PHP `fileinfo` 有一个编译时占用内存过大的[问题](https://bugs.php.net/bug.php?id=65106)，在 PHP 8.4 才被[修复](https://github.com/php/php-src/commit/bcd3eec44aa4e4eeb7deb4ee6b6cfb596dcc7baa)。交换空间没有解决问题，可能是因为编译器需要七八百 MiB 的整块内存，交换空间并不能满足这个需求。我更换 PHP 版本为 8.4，成功解决 fileinfo 的安装问题。

之后，维基看似正常运行了，但之后发现无法编辑页面，提示 SQL 查询出错：

> A database query error has occurred. Did you forget to run your application's database schema updater after upgrading or after adding a new extension?
>
> Please see https://www.mediawiki.org/wiki/Special:MyLanguage/Manual:Upgrading and https://www.mediawiki.org/wiki/Special:MyLanguage/Manual:How_to_debug for more information.
{: lang="en"}

我在迁移维基时顺便把 MediaWiki 版本从 1.43 升级到了 1.45，并把不支持新版本的 DynamicPageList3 扩展换成了 DynamicPageList4，大概是升级之后，数据库表结构需要更新，于是我执行 MediaWiki 维护脚本进行数据库升级：

~~~bash
php maintenance/run.php update
~~~

维护脚本报错：

> **Warning:** you have SQLite 3.26.0, which is lower than minimum required version 3.31.0. SQLite will be unavailable.
{: lang="en"}

原来 MediaWiki 从 1.45.0 版本起将要求的最低 SQLite 版本从 3.24.0 升到了 3.31.0，但系统的包管理最高只提供了 3.26.0，我只好手动从源代码编译：

~~~bash
wget https://sqlite.org/2026/sqlite-autoconf-3530200.tar.gz
tar zxf sqlite-autoconf-3530200.tar.gz
cd sqlite-autoconf-3530200/
./configure --prefix=/usr/local
make -j1 && make install
~~~

编译成功后还需要手动应用新版本库文件：

~~~bash
mv /usr/bin/sqlite3 /usr/bin/sqlite3_bak
ln -s /usr/local/bin/sqlite3 /usr/bin/sqlite3
echo "/usr/local/lib" > /etc/ld.so.conf.d/sqlite3.conf
ldconfig
~~~

之后需要重新安装 PHP 的 pdo_sqlite 扩展，由于这个扩展是宝塔面板安装 PHP 时自带的，我用宝塔面板卸载后重新安装 PHP 才成功解决问题。
