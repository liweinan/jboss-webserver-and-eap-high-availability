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

这个专栏会在豆瓣和微博上连载，同时会在GitHub上面形成[电子书](https://github.com/
liweinan/thoughts-on-jboss-webserver)。原计划是用全英文写这个专栏，但写道快20页
的时候改变想法了，最终决定使用中文来写，慢慢放出。

# Tomcat Vault

Tomcat 
Vault是为Tomcat做配置文件的数据加密小工具，它的Git仓库[在这里](https://github.co
m/picketbox/tomcat-vault)。
