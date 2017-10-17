# UIImage-Mosaic

![](https://img.shields.io/badge/platform-iOS-red.svg) 
![](https://img.shields.io/badge/language-Swift-orange.svg) 
![](https://img.shields.io/badge/download-2.5MB-brightgreen.svg)
![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

马赛克这种东西，你当然可能会用得到，当然还有毛玻璃效果~

| 名称 |1.列表页 |2.展示页 |3.结果页 |
| ------------- | ------------- | ------------- | ------------- |
| 截图 | ![](http://og1yl0w9z.bkt.clouddn.com/17-7-6/49394070.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-7-6/43197086.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-7-6/14637275.jpg) |
| 描述 | 通过 storyboard 搭建基本框架 | 字典排列前 | 字典排列后 |


## Advantage 框架的优势
* 1.文件少，代码简洁
* 2.不依赖任何其他第三方库
* 
* 5.具备较高自定义性

## Installation 安装
### 1.手动安装:
`下载Demo后,将功能文件夹拖入到项目中, 导入头文件后开始使用。`
### 2.CocoaPods安装:
修改“Podfile”文件
```
pod 'AutoAlignButtonTools',:git => 'https://github.com/ReverseScale/AutoAlignButtonToolsCocoapodsDemo.git'
```
控制台执行 Pods 安装命令 （ 简化安装：pod install --no-repo-update ）
```
pod install
```
> 如果 pod search 发现不是最新版本，在终端执行pod setup命令更新本地spec镜像缓存，重新搜索就OK了

## Requirements 要求
* iOS 7+
* Xcode 8+


## Usage 使用方法
### 第一步 引入头文件
```
#import "OrderDic.h"
```
### 第二步 简单调用
```
[OrderDic order:dic]
```

使用简单、效率高效、进程安全~~~如果你有更好的建议,希望不吝赐教!


## License 许可证
OrderedDictionaryTools 使用 MIT 许可证，详情见 LICENSE 文件。


## Contact 联系方式:
* WeChat : WhatsXie
* Email : ReverseScale@iCloud.com
* Blog : https://reversescale.github.io

