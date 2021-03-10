---
title: 基于Docker的Android源码编译过程
author: LanXuage
date: 2021-03-10 00:00:00 +0800
categories: [CTF, 逆向]
tags: [Docker, Android, 源码编译]
---
# 基于 docker 的 Android 源码编译过程

## 环境准备

### 拉取 ubuntu 镜像

```shell
docker pull ubuntu
```

### 启动容器

```shell
docker run -it ubuntu bash
```

### Ubuntu 换源（可选）

参照 [Ubuntu 镜像使用帮助](https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/)

### 依赖安装

```shell
apt install python3 axel curl

# 可选，最新安装的 python3 并不会占用 python。
ln -s /usr/bin/python3 /usr/bin/python
```

### repo 安装

```
curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo

chmod +x /usr/local/bin/repo
```

### Android 镜像拉取

```shell
axel -n 10 https://mirrors.tuna.tsinghua.edu.cn/aosp-monthly/aosp-latest.tar # axel 多线程下载，也可以使用 wget 或者 curl 下载。
```
