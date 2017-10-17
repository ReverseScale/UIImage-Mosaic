//
//  UIImageView+Extension.swift
//  SwifterTemplate
//
//  Created by WhatsXie on 2017/9/22.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import Foundation
import UIKit
extension UIImage{
    //MARK: - 调整图片大小
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width:size.width * heightRatio, height:size.height * heightRatio)
        } else {
            newSize = CGSize(width:size.width * widthRatio, height:size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    //MARK: - 保持图片本色
    func oroginImage() -> UIImage{
        return self.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    //MARK: - 压缩图片
    func compressImage(targetSize:CGSize) -> UIImage {
        if self.size.width > targetSize.width || self.size.height > targetSize.height {
            return self.resizeImage(targetSize: targetSize)
        }
        return self
    }
}

/**
 *  图片填充颜色
 *  保留alpha通道,即保留透明度和颜色灰度
 *
 *  @param tintColor
 *  @param keepAlpha:保留透明度
 *  @param keepGray:保留灰度
 *
 *  @returnnn
 */
extension UIImage{
    func imageWithTintColor(color:UIColor,keepAlpha:Bool,keepGray:Bool)->UIImage{
        //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        color.setFill()
        let bounds = CGRect(x:0, y:0, width:self.size.width, height:self.size.height)
         UIRectFill(bounds)
        if keepGray {
            //kCGBlendModeOverlay保留灰度
            self.draw(in: bounds, blendMode: .overlay, alpha: 1.0)
        }
        if keepAlpha {
            //则再用kCGBlendModeDestinationIn画一次,保留透明度
            self.draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
        }
        let tintImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintImage!
    }
}
//MARK: - 图片外部填充颜色
extension UIImage {
    public func aspectFill(toSize: CGSize) -> UIImage {
        var cropArea = CGRect.zero
        var scale = CGFloat(0)
        
        if size.height > size.width {
            cropArea = CGRect(x: 0, y: (size.height-size.width) / 2, width: size.width, height: size.width)
            scale = size.width / toSize.width
        } else {
            cropArea = CGRect(x: (size.width - size.height)/2, y: 0, width: size.height, height: size.height)
            scale = size.height / toSize.width
        }
        
        let cropImageRef = cgImage!.cropping(to: cropArea)
        return UIImage(cgImage: cropImageRef!, scale: scale, orientation: .up)
    }
}
extension UIImage {
    // 只有当uiImage.cgImage有值的时候才可以使用UIImagePNGRepresentation(_ image: UIImage)
    // 或者UIImageJPEGRepresentation(_ image: UIImage, _ compressionQuality: CGFloat)转换为Data
    func convertUIImageToData(uiImage:UIImage) -> Data {
        var data = UIImagePNGRepresentation(uiImage)
        if data == nil {
            let cgImage = self.convertUIImageToData(uiImage: uiImage)
            let uiImage_ = UIImage.init(cgImage: cgImage as! CGImage)
            data = UIImagePNGRepresentation(uiImage_)
        }
        return data!
    }
}
extension CGImage {
    // CGImage转UIImage相对简单，直接使用UIImage的初始化方法即可
    // 原理同上
    public func convertCGImageToUIImage() -> UIImage {
        let uiImage = UIImage.init(cgImage: self)
        // 注意！！！这里的uiImage的uiImage.ciImage 是nil
        _ = uiImage.ciImage
        // 注意！！！上面的ciImage是nil，原因如下，官方解释
        // returns underlying CIImage or nil if CGImageRef based
        return uiImage
    }
    // CGImage转换CIImage
    func convertCGImageToCIImage() -> CIImage{
        return CIImage.init(cgImage: self)
    }
}
extension CIImage {
    /// CIImage转UIImage相对简单，直接使用UIImage的初始化方法即可
    func convertCIImageToUIImage() -> UIImage {
        let uiImage = UIImage.init(ciImage: self)
        // 注意！！！上面的cgImage是nil，原因如下，官方解释
        // returns underlying CGImageRef or nil if CIImage based
        return uiImage
    }
    // CIImage转换CGImage
    func convertCIImageToCGImage() -> CGImage{
        let ciContext = CIContext.init()
        let cgImage:CGImage = ciContext.createCGImage(self, from: self.extent)!
        return cgImage
    }
}
