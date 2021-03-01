---
title: open-source_攻防世界逆向题集合
author: LanXuage
date: 2021-03-01 00:00:00 +0800
categories: [CTF, 逆向]
tags: [CTF, adworld, reverse, 攻防世界]
---
# open-source

## 文件

file: [8b6405c25fe447fa804c6833a0d72808.c](http://198.74.121.179/adworld/reverse/8b6405c25fe447fa804c6833a0d72808.c)

sha1: 23b35fa93a496385b904e1b74d487e589c436949

## 源码分析

```cpp
#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[]) {
    if (argc != 4) {
        printf("what?\n");
        exit(1);
    }

    unsigned int first = atoi(argv[1]);
    if (first != 0xcafe) {
        printf("you are wrong, sorry.\n");
        exit(2);
    }

    unsigned int second = atoi(argv[2]);
    if (second % 5 == 3 || second % 17 != 8) {
        printf("ha, you won't get it!\n");
        exit(3);
    }

    if (strcmp("h4cky0u", argv[3])) {
        printf("so close, dude!\n");
        exit(4);
    }

    printf("Brr wrrr grr\n");

    unsigned int hash = first * 31337 + (second % 17) * 11 + strlen(argv[3]) - 1615810207;

    printf("Get your key: ");
    printf("%x\n", hash);
    return 0;
}
```

运行需要提供三个参数第一个是`0xcafe`，第二个需要满足`second % 5 == 3 || second % 17 != 8`，第三个是`h4cky0u`。即可得到`key`。

使用gcc编译运行输入三个参数得到结果：

```shell
> ./a.out 51966 25 h4cky0u
Brr wrrr grr
Get your key: c0ffee
```

> 我编译时报错，提示缺少头文件`stdlib.h`，正确导入之后就可以编译成功了。

## flag

c0ffee
