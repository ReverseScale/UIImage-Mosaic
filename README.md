# UIImage-Mosaic

图片加马赛克效果

使用方法：
    @IBOutlet weak var imagev1: UIImageView!
    @IBOutlet weak var imagev2: UIImageView!

    @IBAction func btnClicked(){
        self.imagev2.image = self.imagev1.image!.mosaicImage(6)
    }

效果截图：

![ABC](https://raw.githubusercontent.com/ReverseScale/UIImage-Mosaic/master/Gif.png)
