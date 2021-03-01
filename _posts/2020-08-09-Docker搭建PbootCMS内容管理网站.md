---
title: Docker 搭建 PbootCMS 内容管理网站
author: LanXuage
date: 2020-08-09 10:31:41 +0800
categories: [运维]
tags: [docker, pbootcms]
---

## Docker拉取需要用到的镜像

```sh
docker pull eboraas/apache-php
```

```sh
docker pull mysql
```

## 克隆项目到本地

```sh
git clone https://gitee.com/hnaoyun/PbootCMS.git
```

## 启动一个 eboraas/apache-php 容器

```sh
docker run --name site -d -p 8080:80 -p 8443:443 -v /path/to/PbootCMS:/var/www/html eboraas/apache-php
```

## 进入容器安装php拓展

```sh
# 进入容器
docker exec -it site bash
# 接下来的代码在容器中执行。
# 更换国内镜像源（可选）
sed -i 's/deb.debain.org/mirrors.aliyun.com/g' /etc/apt/sources.list
# 更新仓库和安装包信息
apt update
# 安装所需拓展
apt install php-gd php-mbstring php-curl php-sqlite3
```
## 重启容器激活服务

- 重启容器以生效拓展

```sh
# 重启容器
docker restart site
# 查看容器
docker ps
```

- 激活 PbootCMS

在 `PbootCMS` 官网获取免费授权码，访问自己网站的`admin.php` ，输入默认用户名 `admin` 密码 `123456`。进入【全局配置】-》【配置参数】输入授权码即可正常开始使用服务。

