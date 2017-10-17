//
//  ViewController.swift
//  MosaicDemo
//
//  Created by WhatsXie on 2017/10/17.
//  Copyright © 2017年 WhatsXie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    //原图
    lazy var originalImage: UIImage = {
        return UIImage(named: "img_folder")
        }()!
    
    lazy var context: CIContext = {
        return CIContext(options: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //全图马赛克
    @IBAction func pixAll(_ sender: Any) {
        let filter = CIFilter(name: "CIPixellate")!
        let inputImage = CIImage(image: originalImage)
        filter.setValue(inputImage, forKey: kCIInputImageKey)
//        filter.setValue(25, forKey: kCIInputScaleKey) //值越大马赛克就越大(使用默认)
        let fullPixellatedImage = filter.outputImage
        
        let cgImage = context.createCGImage(fullPixellatedImage!,
                                            from: fullPixellatedImage!.extent)
        imageView.image = cgImage?.convertCGImageToUIImage()
    }
    
    //部分区域马赛克
    @IBAction func pixArea(_ sender: Any) {
        //马赛克全图
        let filter = CIFilter(name: "CIPixellate")!
        let inputImage = CIImage(image: originalImage)!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(22, forKey: kCIInputScaleKey) //值越大马赛克就越大
        let fullPixellatedImage = filter.outputImage
        
        //蒙板创建
        var maskImage: CIImage
        //第一个打码区域（中间大圆）
        var centerX = inputImage.extent.size.width / 2
        let centerY = inputImage.extent.size.height / 2
        var radius = min(inputImage.extent.size.width/3, inputImage.extent.size.height/3)
        var temp = createMaskImage(rect: inputImage.extent, centerX: centerX, centerY: centerY,
                                   radius: radius)
        maskImage = temp
        //第二个打码区域（左边小圆）
        centerX = inputImage.extent.size.width / 6
        radius = min(inputImage.extent.size.width/4, inputImage.extent.size.height/5)
        temp = createMaskImage(rect: inputImage.extent, centerX: centerX, centerY: centerY,
                               radius: radius)
        maskImage = CIFilter(name: "CISourceOverCompositing",
                             withInputParameters: [
                                kCIInputImageKey : temp,
                                kCIInputBackgroundImageKey : maskImage
            ])!.outputImage!
        
        //混合图像输出
        let blendFilter = CIFilter(name: "CIBlendWithMask")!
        blendFilter.setValue(fullPixellatedImage, forKey: kCIInputImageKey)
        blendFilter.setValue(inputImage, forKey: kCIInputBackgroundImageKey)
        blendFilter.setValue(maskImage, forKey: kCIInputMaskImageKey)
        
        let blendOutputImage = blendFilter.outputImage
        let blendCGImage = context.createCGImage(blendOutputImage!, from: blendOutputImage!.extent)
        imageView.image = blendCGImage?.convertCGImageToUIImage()
    }
    
    //恢复原图
    @IBAction func resetImg(_ sender: Any) {
        imageView.image = originalImage
    }
    
    
    //创建打码区域
    func createMaskImage(rect: CGRect ,centerX: CGFloat, centerY: CGFloat, radius:CGFloat)
        -> CIImage{
            let radialGradient = CIFilter(name: "CIRadialGradient",
                                          withInputParameters: [
                                            "inputRadius0" : radius,
                                            "inputRadius1" : radius + 1,
                                            "inputColor0" : CIColor(red: 0, green: 1, blue: 0, alpha: 1),
                                            "inputColor1" : CIColor(red: 0, green: 0, blue: 0, alpha: 0),
                                            kCIInputCenterKey : CIVector(x: centerX, y: centerY)
                ])
            let radialGradientOutputImage = radialGradient!.outputImage!.cropping(to: rect)
            return radialGradientOutputImage
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
