//
//  UIImage+Mosaic.swift
//  Swift-mosaic
//
//  Created by StevenXie on 16/7/19.
//  Copyright © 2016年 StevenXie. All rights reserved.
//

import UIKit

let kBitsPerComponent = 8
let kBitsPerPixel = 32
let kPixelChannelCount = 4

extension UIImage{
    func mosaicImage(level:Int) -> UIImage?{
        //获取BitmapData
        let colorSpace:(CGColorSpaceRef)? = CGColorSpaceCreateDeviceRGB()
        let imgRef:(CGImageRef)? = self.CGImage
        let width = CGImageGetWidth(imgRef)
        let height = CGImageGetHeight(imgRef)
        let context:(CGContextRef)? = CGBitmapContextCreate(nil, width, height, kBitsPerComponent, width * kPixelChannelCount, colorSpace, CGImageAlphaInfo.PremultipliedLast.rawValue)
        
        CGContextDrawImage(context, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), imgRef);
        let bitmapData = CGBitmapContextGetData(context)
        
        //这里把BitmapData进行马赛克转换,就是用一个点的颜色填充一个level*level的正方形
        var pixel = [Int](count: kPixelChannelCount, repeatedValue: 0)
        
        var index:(NSInteger)
        var preIndex:(NSInteger)
        
        for i in 0...height - 1 {
            for j in 0...width - 1 {
                index = i * width + j
                if i % level == 0 {
                    if j % level == 0 {
                        memcpy(&pixel, bitmapData + kPixelChannelCount*index, kPixelChannelCount)
                    } else {
                        memcpy(bitmapData + kPixelChannelCount*index, pixel, kPixelChannelCount);
                    }
                } else {
                    preIndex = (i - 1) * width + j;
                    memcpy(bitmapData + kPixelChannelCount*index, bitmapData + kPixelChannelCount*preIndex, kPixelChannelCount);
                }
            }
        }
        let dataLength:(NSInteger) = width*height * kPixelChannelCount
        let provider:(CGDataProviderRef)? = CGDataProviderCreateWithData(nil, bitmapData, dataLength, nil)
        
        //创建要输出的图像
        let mosaicImageRef:(CGImageRef)? = CGImageCreate(width, height, kBitsPerComponent, kBitsPerPixel, width*kPixelChannelCount, colorSpace, CGBitmapInfo.ByteOrder32Big, provider, nil, false, .RenderingIntentDefault)

        let outputContext:(CGContextRef)? = CGBitmapContextCreate(nil, width, height, kBitsPerComponent, width*kPixelChannelCount, colorSpace, CGImageAlphaInfo.PremultipliedLast.rawValue)
        
        CGContextDrawImage(outputContext, CGRectMake(0.0, 0.0, CGFloat(width), CGFloat(height)), mosaicImageRef);
        let resultImageRef:(CGImageRef)? = CGBitmapContextCreateImage(outputContext);
        let resultImage:(UIImage)?
        let scale:(CGFloat) = UIScreen .mainScreen().scale
        
        resultImage = UIImage(CGImage: resultImageRef!, scale: scale, orientation: .Up)

        return resultImage;
    }
}


