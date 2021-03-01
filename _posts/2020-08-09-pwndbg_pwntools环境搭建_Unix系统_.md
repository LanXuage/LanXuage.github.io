---
title: pwndbg、pwntools环境搭建（Unix系统）
author: LanXuage
date: 2020-08-09 10:10:32 +0800
categories: [学习, pwn学习]
tags: [pwn, pwntools, gdb, pwndbg]
---

## pwndbg环境搭建
### 项目地址

```shell
https://github.com/pwndbg/pwndbg
```

### 搭建过程

#### 1、安装环境基础
- git
- python
- python-pip

#### 2、安装过程

- 使用git命令克隆远程项目到本地。
```shell
git clone https://github.com/pwndbg/pwndbg
```

- 进入项目根目录并执行一键安装脚本
```shell
cd pwndbg && ./setup.sh
```
> 该脚本主要是检查了一下系统信息，然后根据系统信息自动安装了一些所需要的工具和依赖库包括gdb，当然有时需要通过源码去编译gdb。

#### 3、配置启用pwndbg

安装完成后，通过编辑用户目录下的gdb配置文件`.gdbinit`，痛过该文件可以启用pwngdb，主要在文件中添加的内容如下，
```shell
# 文件路径为所克隆的项目的路径。
source [/path/to/pwndbg/gdbinit.py] 
```

#### 4、问题

待补充。。。

## pwntools安装

### 项目地址

```shell
https://github.com/Gallopsled/pwntools/
```

### 搭建过程

#### 1、安装环境

- python
- python-pip

#### 2、安装过程

- 使用pip命令直接安装
```shell
pip install pwntools
```

#### 4、问题

待补充。。。

## 环境使用

### pwndbg使用

#### 程序动态调试

```shell
# 直接gdb后面接程序进入程序调试
gdb [/path/to/program]
```

#### pwngdb常用命令

- `info`
> 信息查看
> `info functions`查看所有函数的信息。
> `info breakpoints`查看所有断点的信息。
> `info registers`查看所有寄存器的信息。
> `info watchpoints`查看所有内存断点的信息。
> `info threads`查看所有线程的信息。
- `run`
> 直接运行程序直到遇见断点。
- `start`
> debug模式停在main()，否则停在start()。
- `break`
> 下断点，后面可直接加函数名表示在该函数的开头处下断点，也可以直接加地址不过需要在地址前加上一个`*`号。如，`break main`或者`break *0xdeadbeaf`。
- `delete`
> 可以使用delete来删除断点，`delete breakpoints`删除所有断点，delete 加上一个序号可以删除指定的断点。
- `stack`
> 查看栈里的内容。
- `x`
> 查看指定内存地址的内容。
> 一般是x/[n/f/u]的形式，其中n、f、u为控制打印形式的参数
> n代表打印格式，可为o(八进制),x(十六进制),d(十进制),u(无符号十进制),t(二进制),f(浮点类型),a(地址类型),i(解析成命令并反编译),c(字符)和s(字符串)
> f 用来设定输出长度，b(byte),h(halfword),w(word),giant(8bytes)。
> u 指定单位内存单元的字节数(默认为dword) 可用b(byte),h(halfword),w(word),giant(8bytes)替代x指令也可以显示地址上的指令信息，用法：x/i
- `checksec`
> 检查程序的保护机制。
- `next`
> 动态调试命令，单步步过。
- `step`
> 动态调试命令，单步步入。
- `finish`
> 执行到当前函数的返回处。
- `vmmap`
> 查看程序堆栈结构。
- `search`
> 搜索内存中的信息。

待补充。。。

## 问题

。。。