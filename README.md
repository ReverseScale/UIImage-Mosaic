# UIImage-Mosaic

![](https://img.shields.io/badge/platform-iOS-red.svg) 
![](https://img.shields.io/badge/language-Swift-orange.svg) 
![](https://img.shields.io/badge/download-2.5MB-brightgreen.svg)
![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

马赛克这种东西，你当然可能会用得到，当然还有毛玻璃效果~

| 名称 |1.列表页 |2.马赛克页 |3.毛玻璃页 |
| ------------- | ------------- | ------------- | ------------- |
| 截图 | ![](http://og1yl0w9z.bkt.clouddn.com/17-10-17/38612617.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-10-17/50454310.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-10-17/42310312.jpg) |
| 描述 | 通过 storyboard 搭建基本框架 | 马赛克效果 | 毛玻璃效果 |


## Advantage 框架的优势
* 1.文件少，代码简洁
* 2.不依赖任何其他第三方库
* 3.支持延展工具扩展
* 4.具备较高自定义性


## Requirements 要求
* iOS 7+
* Xcode 8+
* Swift 4+


## Usage 使用方法
### 第一步 马赛克（事件）
```
let filter = CIFilter(name: "CIPixellate")!
let inputImage = CIImage(image: originalImage)
filter.setValue(inputImage, forKey: kCIInputImageKey)
//        filter.setValue(25, forKey: kCIInputScaleKey) //值越大马赛克就越大(使用默认)
let fullPixellatedImage = filter.outputImage

let cgImage = context.createCGImage(fullPixellatedImage!,
                                    from: fullPixellatedImage!.extent)
imageView.image = cgImage?.convertCGImageToUIImage()
```
### 第二步 毛玻璃
```
//首先创建一个模糊效果
let blurEffect = UIBlurEffect(style: .dark)
//接着创建一个承载模糊效果的视图
let blurView = UIVisualEffectView(effect: blurEffect)
//设置模糊视图的大小（全屏）
blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)

//创建并添加vibrancy视图
let vibrancyView = UIVisualEffectView(effect:
    UIVibrancyEffect(blurEffect: blurEffect))
vibrancyView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
blurView.contentView.addSubview(vibrancyView)
```

使用简单、效率高效、进程安全~~~如果你有更好的建议,希望不吝赐教!


## License 许可证
UIImage-Mosaic 使用 MIT 许可证，详情见 LICENSE 文件。


## Contact 联系方式:
* WeChat : WhatsXie
* Email : ReverseScale@iCloud.com
* Blog : https://reversescale.github.io

