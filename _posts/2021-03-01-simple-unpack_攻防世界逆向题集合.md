---
title: simple-unpack_攻防世界逆向题集合
author: LanXuage
date: 2021-03-01 00:00:00 +0800
categories: [CTF, 逆向]
tags: [CTF, adworld, reverse, 攻防世界]
---
# simple-unpack

## 文件

file: [847be14b3e724782b658f2dda2e8045b](http://198.74.121.179/adworld/reverse/847be14b3e724782b658f2dda2e8045b)

sha1: 50825bf9b69b0e72e3342edb87d2ce3ac022c0ab

## 查壳

### Die 查壳工具

![](/assets/image/simple-unpack/1614567295778.png)

> 该ELF文件使用UPX进行了加壳。加了壳的程序直接分析很麻烦，很不友好，只能先脱壳。

### 脱壳

直接使用`linux`命令`upx`进行脱壳操作：

```shell
> upx -d 847be14b3e724782b658f2dda2e8045b
                       Ultimate Packer for eXecutables
                          Copyright (C) 1996 - 2020
UPX 3.96        Markus Oberhumer, Laszlo Molnar & John Reiser   Jan 23rd 2020

        File size         Ratio      Format      Name
   --------------------   ------   -----------   -----------
    912808 <-    352624   38.63%   linux/amd64   847be14b3e724782b658f2dda2e8045b

Unpacked 1 file.
```

> upx 可以使用命令`apt install upx-ucl`进行安装。上面的命令会将脱完壳的程序直接覆盖原文件。

对脱壳后的文件使用`strings`命令过滤一下关键字，即可得到`flag`。

```shell
> strings 847be14b3e724782b658f2dda2e8045b| grep flag
WARNING: Unsupported flag value(s) of 0x%x in DT_FLAGS_1.
s->_flags2 & _IO_FLAGS2_FORTIFY
version == NULL || (flags & ~(DL_LOOKUP_ADD_DEPENDENCY | DL_LOOKUP_GSCOPE_LOCK)) == 0
imap->l_type == lt_loaded && (imap->l_flags_1 & DF_1_NODELETE) == 0
flag{Upx_1s_n0t_a_d3liv3r_c0mp4ny}
flag
_dl_stack_flags
```

## flag

flag{Upx_1s_n0t_a_d3liv3r_c0mp4ny}
