---
title: 基于Android Studio 编译XposedBridge源码生产用于开发插件的jar包
author: LanXuage
date: 2020-08-08 19:36:00 +0800
categories: [学习, Xposed学习]
tags: [Xposed, Android Studio, XposedBridge]
---

## `XposedBridge`项目地址
> `https://github.com/rovo89/XposedBridge`

## 编译过程
### 克隆项目源码到本地

```sh
git clone https://github.com/rovo89/XposedBridge
```

### 将源码导入到 `Android Studio` 中

使用 `Android Studio` ：File -> Open -> 【选中项目目录】-> OK

### 修改配置文件（可选）

修改项目目录下的 `app` 目录里的 `build.gradle` 构建文件，将 `assert sdkSources.exists()` 注释掉。

### 使用 `gradle` 构建 `jar` 包

等待 `gradle` 自动配置好依赖环境后，打开项目目录下的 `app` 目录里的 `build.gradle` 构建文件，运行 `generateAPI` 构建任务，具体操作为找到文件中以 `task generateAPI` 开头的一行代码，在这行代码的左边有一个绿色三角（可运行标志），若没有该可运行标志，应该是前面的 `Android Studio` 在进行自动 `gradle` 依赖等配置时由于网络或者某些原因失败了，检查环境再重新导入 `Android Studio`  可以解决。点击该可运行标志，选择 `Run 'XposedBridge' [generateAPI]` 后， `Android Studio`  便会开始构建 `API` 的 `jar` 包，观察输出，没有明显错误且最后显示 `BUILD SUCCESSFUL` 字样的话，也就算是构建 `jar` 包成功了。`jar` 包默认保存在 `app` 目录下的 `build/api` 路径下，文件名默认为 `api.jar` 和 `api-source.jar`。

## 问题

。。。