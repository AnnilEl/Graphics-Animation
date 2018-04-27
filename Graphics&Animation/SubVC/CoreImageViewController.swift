//
//  CoreImageViewController.swift
//  Graphics&Animation
//
//  Created by CharlieW on 2018/4/26.
//  Copyright © 2018年 CharlieW. All rights reserved.
//

import UIKit
import Photos
/**
 Core Image:
 
 CIContext。 核心图像的所有处理都在CIContext中完成。 这有点类似于核心图形或OpenGL上下文。
 CIImage。 这个类保存图像数据。 它可以通过UIImage，图像文件或像素数据创建。
 CIFilter。 CIFilter类有一个字典，它定义了它所表示的特定过滤器的属性。 过滤器的例子有振动，颜色反转，裁剪等等。
 
 */

/**
CIFilter：
 创建一个CIImage对象。 CIImage有几种初始化方法，包括：CIImage（contentsOfURL :)，CIImage（data :)，CIImage（CGImage :)，CIImage（bitmapData：bytesPerRow：size：format：colorSpace :)等等。 大多数情况下，您很可能正在使用CIImage（contentsOfURL :)。
 创建一个CIContext。 CIContext可以是基于CPU或GPU的。 CIContext初始化相对昂贵，因此您可以重复使用它，而不是一遍又一遍地创建它。 输出CIImage对象时总是需要一个。
 创建一个CIFilter。 在创建过滤器时，可以在其上配置多个属性，这些属性取决于您使用的过滤器。
 获取过滤器输出。 该过滤器为您提供了一个输出图像作为CIImage - 您可以使用CIContext将其转换为UIImage，
 
 */


class CoreImageViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var amountSlider: UISlider!
    
    var context: CIContext!
    
    var filter: CIFilter!
    
    var beginImg: CIImage!
    
    var orientation: UIImageOrientation = .up
    
    
    let fileUrl = Bundle.main.url(forResource: "image", withExtension: "png")!
    
    @IBAction func amountSliderValueChanged(_ sender: UISlider) {
        let sliderValue = sender.value
//        filter.setValue(sliderValue, forKey: kCIInputIntensityKey)
//        let outputImg = filter.outputImage
        let outputImg = oldPhoto(img: beginImg, intensity: sliderValue)
        
        let cgimg = context.createCGImage(outputImg, from: (outputImg.extent))
        let newImg = UIImage(cgImage: cgimg!, scale: 1, orientation: orientation)
        self.imgView.image = newImg
    }
    
    @IBAction func loadPhoto(_ sender: UIButton) {
        let pickerVC = UIImagePickerController()
        pickerVC.delegate = self
        self.present(pickerVC, animated: true, completion: nil)
    }
    
/**
     当将照片保存到相册时，可能需要几秒钟的时间，即使关闭应用程序，该过程仍可能继续。
     
     这可能是一个问题，因为当你从一个应用程序切换到另一个应用程序时，GPU会停止正在执行的任何操作。如果照片没有完成保存，当您稍后再去寻找照片时，照片不会存在！
     
     解决方案是使用基于CPU的CIContext进行渲染。默认行为是使用GPU，因为它速度更快，并且您不希望为了添加保存功能而减慢过滤性能。相反，您将创建第二个CIContext用于保存图像。请注意，软件渲染器在模拟器中无法正常工作。

 */
    @IBAction func savePhoto(_ sender: UIButton) {
        let imageToSave = filter.outputImage
        
        let softwareContext = CIContext(options: [kCIContextUseSoftwareRenderer: true])
        
        let cgimg = softwareContext.createCGImage(imageToSave!, from: (imageToSave?.extent)!)
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: UIImage(cgImage: cgimg!))
        }) { (success, error) in
            if success {
            } else {
                print(error)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginImg = CIImage(contentsOf: fileUrl)!

        filter = CIFilter(name: "CISepiaTone")!
        filter.setValue(beginImg, forKey: kCIInputImageKey)
        filter.setValue(0.5, forKey: kCIInputIntensityKey)
        
        let outputImg = filter.outputImage
        
        context = CIContext(options: nil)
        
        let cgimg = context.createCGImage(outputImg!, from: (outputImg?.extent)!)
        

        // 每个CIFilter必须对应一个CIContext.UIImage(ciImage:)隐性的创建了一个CIContext
        // 每使用一次创建一次，会很影响性能
//        let newImg: UIImage = UIImage(ciImage: filter.outputImage!)
//        imgView.image = newImg
        
//        let cgimg = context.createCGImage(filter.outputImage!, from: (filter.outputImage?.extent)!)
        let newImg = UIImage(cgImage: cgimg!)
        imgView.image = newImg
        
//        logAllFilters()
    }
    
    func oldPhoto(img: CIImage, intensity: Float) -> CIImage {
        let sepia = CIFilter(name: "CISepiaTone")
        sepia?.setValue(img, forKey: kCIInputImageKey)
        sepia?.setValue(intensity, forKey: "inputIntensity")
        
        let random = CIFilter(name: "CIRandomGenerator")
        
        let lighten = CIFilter(name: "CIColorControls")
        lighten?.setValue(random?.outputImage, forKey: kCIInputImageKey)
        lighten?.setValue(1 - intensity, forKey: "inputBrightness")
        lighten?.setValue(0, forKey: "inputSaturation")
        
        let croppedImg = lighten?.outputImage?.cropped(to: beginImg.extent)
        
        let composite = CIFilter(name:"CIHardLightBlendMode")!
        composite.setValue(sepia?.outputImage, forKey:kCIInputImageKey)
        composite.setValue(croppedImg, forKey:kCIInputBackgroundImageKey)
        
        let vignette = CIFilter(name:"CIVignette")!
        vignette.setValue(composite.outputImage, forKey:kCIInputImageKey)
        vignette.setValue(intensity * 2, forKey:"inputIntensity")
        vignette.setValue(intensity * 30, forKey:"inputRadius")
        
        return vignette.outputImage!
    }
    
/**
     CIFilter API在Mac OS上有超过160个过滤器，其中126个在iOS 8上可用

     可以使用CIFilter方法filterNamesInCategory（kCICategoryBuiltIn）。 此方法将返回一组过滤器名称。
     每个过滤器都有一个attributes（）方法，它将返回一个包含有关该过滤器信息的字典。 该信息包括过滤器的名称和类别，过滤器所采用的输入类型以及这些输入的默认值和可接受值。
 */
    func logAllFilters() {
        let properties = CIFilter.filterNames(inCategory: kCICategoryBuiltIn)
        print(properties)
        
        for filterName: Any in properties {
            let fltr = CIFilter(name: filterName as! String)
            print(fltr?.attributes)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension CoreImageViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //  请注意，无论何时执行任何UIImagePickerControllerDelegate方法，都必须在实现中明确地关闭UIImagePickerController。
        self.dismiss(animated: true, completion: nil)
        print(info)
        
        let gotImg = info[UIImagePickerControllerOriginalImage] as! UIImage
        orientation = gotImg.imageOrientation
        beginImg = CIImage(image: gotImg)
        filter.setValue(beginImg, forKey: kCIInputImageKey)
        self.amountSliderValueChanged(amountSlider)
        
    }
    
}
