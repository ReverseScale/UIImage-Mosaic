# UIImage-Mosaic

![](https://img.shields.io/badge/platform-iOS-red.svg) 
![](https://img.shields.io/badge/language-Swift-orange.svg) 
![](https://img.shields.io/badge/download-2.5MB-brightgreen.svg)
![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

马赛克这种东西，你当然可能会用得到，当然还有毛玻璃效果~

| 名称 |1.列表页 |2.马赛克页 |3.毛玻璃页 |4.人脸识别打码|
| ------------- | ------------- | ------------- | ------------- | ------------- |
| 截图 | ![](http://og1yl0w9z.bkt.clouddn.com/17-10-23/20562310.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-10-17/50454310.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-10-17/42310312.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-10-23/51071578.jpg) |
| 描述 | 通过 storyboard 搭建基本框架 | 马赛克效果 | 毛玻璃效果 | 人脸识别打码效果 |


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
### 马赛克（事件）
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
### 毛玻璃
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
### 人脸识别
```
// 用CIPixellate滤镜对原图先做个完全马赛克
let filter = CIFilter(name: "CIPixellate")!
print(filter.attributes)
let inputImage = CIImage(image: originalImage)!
filter.setValue(inputImage, forKey: kCIInputImageKey)
let inputScale = max(inputImage.extent.size.width, inputImage.extent.size.height) / 80
filter.setValue(inputScale, forKey: kCIInputScaleKey)
let fullPixellatedImage = filter.outputImage

// 检测人脸，并保存在faceFeatures中
let detector = CIDetector(ofType: CIDetectorTypeFace,
                          context: context,
                          options: nil)
let faceFeatures = detector?.features(in: inputImage)
// 初始化蒙版图，并开始遍历检测到的所有人脸
var maskImage: CIImage!
for faceFeature in faceFeatures! {
    print(faceFeature.bounds)
    // 基于人脸的位置，为每一张脸都单独创建一个蒙版，所以要先计算出脸的中心点，对应为x、y轴坐标，
    // 再基于脸的宽度或高度给一个半径，最后用这些计算结果初始化一个CIRadialGradient滤镜
    let centerX = faceFeature.bounds.origin.x + faceFeature.bounds.size.width / 2
    let centerY = faceFeature.bounds.origin.y + faceFeature.bounds.size.height / 2
    let radius = min(faceFeature.bounds.size.width, faceFeature.bounds.size.height)
    let radialGradient = CIFilter(name: "CIRadialGradient",
                                  withInputParameters: [
                                    "inputRadius0" : radius,
                                    "inputRadius1" : radius + 1,
                                    "inputColor0" : CIColor(red: 0, green: 1, blue: 0, alpha: 1),
                                    "inputColor1" : CIColor(red: 0, green: 0, blue: 0, alpha: 0),
                                    kCIInputCenterKey : CIVector(x: centerX, y: centerY)
        ])!
    print(radialGradient.attributes)
    // 由于CIRadialGradient滤镜创建的是一张无限大小的图，所以在使用之前先对它进行裁剪
    let radialGradientOutputImage = radialGradient.outputImage!
        .cropped(to: inputImage.extent)
    if maskImage == nil {
        maskImage = radialGradientOutputImage
    } else {
        print(radialGradientOutputImage)
        maskImage = CIFilter(name: "CISourceOverCompositing",
                             withInputParameters: [
                                kCIInputImageKey : radialGradientOutputImage,
                                kCIInputBackgroundImageKey : maskImage
            ])!.outputImage
    }
}
// 用CIBlendWithMask滤镜把马赛克图、原图、蒙版图混合起来
let blendFilter = CIFilter(name: "CIBlendWithMask")!
blendFilter.setValue(fullPixellatedImage, forKey: kCIInputImageKey)
blendFilter.setValue(inputImage, forKey: kCIInputBackgroundImageKey)
blendFilter.setValue(maskImage, forKey: kCIInputMaskImageKey)
// 输出，在界面上显示
let blendOutputImage = blendFilter.outputImage
let blendCGImage = context.createCGImage(blendOutputImage!,
                                         from: blendOutputImage!.extent)
imageView.image = blendCGImage?.convertCGImageToUIImage()
```

使用简单、效率高效、进程安全~~~如果你有更好的建议,希望不吝赐教!


## License 许可证
UIImage-Mosaic 使用 MIT 许可证，详情见 LICENSE 文件。


## Contact 联系方式:
* WeChat : WhatsXie
* Email : ReverseScale@iCloud.com
* Blog : https://reversescale.github.io

