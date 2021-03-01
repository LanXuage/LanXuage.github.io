---
title: 基于Android Studio创建Xposed插件应用
author: LanXuage
date: 2020-08-08 19:36:00 +0800
categories: [学习, Xposed学习]
tags: [Xposed, Android Studio]
---

## 基本环境

- Android Studio
- 安卓模拟器或实体机（安装有Xposed+root或者安装VirtualXposed）

## 创建空白项目

File -> New -> New Project -> Empty Activity -> 【配置项目信息】-> Finish

## 修改配置文件

### 配置 app/build.gradle

- 配置编译SDK版本为 `28` ，即将 `android` 里的 `compileSdkVersion` 的值修改为 `28` 。

- 配置目标SDK版本为 `28`，即将 `android` -> `defaultConfig` 里的 `targetSdkVersion` 的值修改为 `28` 。

> 注意：之所以设置为 `28` ，主要是经过我的测试，在 `virtualxposed` 中使用高于 `28` 的SDK，都会发生失败，无法反射到数据。

- 配置 `appcompat` 依赖，即替换 `dependencies` 里的

```gradle
implementation 'androidx.appcompat:appcompat:1.1.0'
```

为

```gradle
implementation 'com.android.support:appcompat-v7:28.0.0'
```

没有的话直接添加。

- 添加 `xposed api` 依赖，即将 `xposed` 的 `api.jar` 包放入libs目录中，再在 `app/build.gradle` 文件的 `dependencies`  里添加一行

```gradle
compileOnly files("libs/api.jar")
```

- 最后同步 `Asyn` ，即运行 `gradle` 同步依赖。

### 配置 AndroidManifest.xml

在 `application` 里添加下面内容
```xml
<!-- 是否是xposed模块 -->
<meta-data android:name="xposedmodule" android:value="true" />
<!-- 该xposed模块的描述 -->
<meta-data android:name="xposeddescription" android:value="The first xposed 
app." />
<!-- 该xposed支持的最低xposed版本 -->
<meta-data android:name="xposedminversion" android:value="57" />
```

## 创建入口类

- 在项目中创建一个类并实现 `IXposedHookLoadPackage`  作为入口类。

内容如下
```java
package com.xuange.wehook;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

public class Main implements IXposedHookLoadPackage {
    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) throws Throwable {
        XposedBridge.log(String.format("#### packageName = %S", lpparam.packageName));
    }
}
```

- 创建 `assets`  文件夹，右键app目录 -> New -> Folder -> Assets Folder -> Finish。

- 在 `assets`  文件夹下创建 `xposed_init` 文件用于指定入口类，内容为入口类的包路径包含类名。

## 运行

。。。
