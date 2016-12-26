---
title: "阿男的WEB服务器架构指南"
author: Weinan Li
output: pdf_document
mainfont: "FZBaoSong-Z04S"
CJKmainfont: "FZBaoSong-Z04S"
CJKoptions:
  - BoldFont=FZMeiHei-M07S
  - ItalicFont=STFangsong
  - Scale=1.0
---

# 介绍

在这个专栏，阿男想为大家介绍以Apache HTTPD和Apache 
Tomcat为主的WEB服务器架构方案，特别是会为大家介绍以`mod_cluster`和`mod_jk`为主的
负载平衡解决方案。此外阿男还会为大家重点介绍openssl在WEB架构中的相关应用和使用方
法。

这个专栏会在豆瓣和微博上连载，同时会在GitHub上面形成电子书[^1]。原计划是用全英文
写这个专栏，但写道快20页的时候改变想法了，最终决定使用中文来写，慢慢放出。

[^1]: https://github.com/liweinan/thoughts-on-jboss-webserver

# Tomcat Vault

Tomcat 
Vault是为Tomcat做配置文件的数据加密小工具，它的Git仓库在这里[^2]。阿男在这里为大
家介绍它的使用方法。

[^2]: https://github.com/picketbox/tomcat-vault

## Tomcat Vault的设计思路

在Tomcat的用户配置文件里面，用户名和密码都是明文保存的。我们可以看一下`conf`目录
中的`tomcat-users.xml`：

```bash
mini:conf weinanli$ pwd
/Users/weinanli/projs/apache-tomcat-8.5.9/conf
mini:conf weinanli$ ls tomcat-users.xml
tomcat-users.xml
```

查看这个文件里面的内容：

```xml
<user username="tomcat" password="foo" roles="tomcat"/>
```

可以看到password都是明文保存的。为了解决这个问题，我们就要用到tomcat-vault。tomc
at-vault使用Java的KeyStore来保存密钥，并使用密钥进行数据的加解密。

因为Java的KeyStore是标准的SSL和JSE规范下的加解密方案，因此避免了自己"发明"一些安
全方案而造成的不安全因素。

阿男在接下来的几篇文章里，为大家介绍Tomcat Vault的使用方法。
