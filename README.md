# 一博
开源的博客客户端iOS版，支持Wordpress及metaWeblog Api博客。

An open source blog client for ios plantform.It supports Wordpress and other blogs which uses metaWeblog Api.

[![Build Status](https://api.travis-ci.org/terwer/OneblogiOS.svg)](https://travis-ci.org/terwer/OneblogiOS)

版本信息
-------
>版本: V0.9

>开发工具：Version 6.4 (6E35b) iOS7.0+

>开发环境：Mac Pro OS X Yosemite 10.10.4

>作者: Terwer Green

>作者博客：http://www.terwer.com

>作者邮箱: cbgtyw@gmail.com

演示
---
1、启动界面

![](Images/0.png)

2、首页

![](Images/1.png)

3、侧拉

![](Images/2.png)

4、发布

![](Images/3.png)

## 运行项目
1. 安装CocoaPods (关于CocoaPods的安装和使用，可参考[这个教程](http://blog.devtang.com/blog/2014/05/25/use-cocoapod-to-manage-ios-lib-dependency/))
2. 在终端下打开项目所在的目录，执行```pod install``` (若是首次使用CocoaPods，需先执行```pod setup```)
3. ```pod install```命令执行成功后，通过新生成的xcworkspace文件打开工程运行项目

## 目录简介
* API ——— 包含API和API返回数据的封装模型
* Utils ——— 常用的工具方法、类扩展及一些控件
* 博客、消息、发现...... ——— 各个具体界面
* Main ViewControllers ——— 主要的视图控制器（作为基类或使用较广的控制器）

## 项目用到的开源类库、组件

序号 | 类库名称 | 说明
------------- | ------------- | -------------
1             | AFNetworking  | 网络请求
14            | TGMetaWeblogApi | MetaWeblogApi https://github.com/terwer/TGMetaWeblogApi
15            | SDFeedParser | Wordpress JSON API https://github.com/terwer/SDFeedParser
4             | RESideMenu       | 侧拉栏
5             | MBProgressHUD    | 显示提示或加载进度
6             | SDWebImage       | 加载网络图片和缓存图片
8             | TTTAttributedLabel | 支持富文本显示的label
10            | GPUImage         | 实现模糊效果
11            | libNBSAppAgent | App性能监控（ http://www.tingyun.com/ ）
12            | FontAwesome      | 图标字体（ http://fortawesome.github.io/Font-Awesome/icons/ ）
13            | MZDayPicker      | 日期
14            | AttributedMarkdown | 解析文章详情

## 开源协议
Oneblog app is under the Apache License V2. See [the LICENSE file](https://github.com/terwer/OneblogiOS/blob/master/LICENSE.md) for more details.

更新记录
======

v0.9.2 2015-07-29

>1、完善博文列表显示。
>2、完善左侧侧拉菜单。

v0.9.1 2015-07-25

>调整项目结构。

v0.9 2015-07-08

>1、项目重新规划。  
>2、完善启动界面。

参考资料  
=======

1、[浅析利用MetaWeblog接口同步多个博客](http://developer.51cto.com/art/200907/135453.htm)

2、[Launch Screen在iOS7/8中的实现](http://blog.shiqichan.com/Launch-Screen-in-iOS-7-and-8/)

3、[Xcode6后手动添加.pch文件](http://www.bkjia.com/Androidjc/979939.html)
