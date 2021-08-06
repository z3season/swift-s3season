//
//  CoreImageVC.swift
//  SwiftS3season
//
//  Created by season on 2021/7/28.
//

import UIKit
import GLKit

/*
 CIImage 保存图像数据的类，可以通过UIImage，图像文件或者像素数据来创建，包括未处理的像素数据。
 CIFilter 表示应用的滤镜，这个框架中对图片属性进行细节处理的类。它对所有的像素进行操作，用一些键-值设置来决定具体操作的程度。
 CIContext 表示上下文，如 Core Graphics 以及 Core Data 中的上下文用于处理绘制渲染以及处理托管对象一样，Core Image 的上下文也是实现对图像处理的具体对象。可以从其中取得图片的信息。
 */

class CoreImageVC: BaseViewController {

//    var filter: CIFilter?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.addSubview(self.imageView)
//        self.view.addSubview(sliderBar)
//
//        CustomFilter.register()
//        filter = CIFilter(name: "CustomFilter")
//
//        guard let cgImage = UIImage(named: "faye1")?.cgImage else { return }
//        let ciImage = CIImage(cgImage: cgImage)
//        filter?.setValue(ciImage, forKey: kCIInputImageKey)
//    }
//
//    @objc func sliderValueChange(_ sender:UISlider) {
//        filter?.setValue(sender.value, forKey: "radius")
//        if let outputImage = filter?.outputImage {
//            self.imageView.image = UIImage(ciImage: outputImage)
//        }
//    }
//
//    private lazy var imageView:UIImageView = {
//        let temp = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 60))
//        temp.contentMode = .scaleAspectFill
//        temp.image = UIImage(named: "icon_image1")
//        return temp
//    }()
//
//    private lazy var sliderBar:UISlider = {
//        let temp = UISlider(frame: CGRect(x: 20.0, y: SCREEN_HEIGHT - 200, width: SCREEN_WIDTH - 40, height: 30))
//        temp.minimumValue = 1
//        temp.maximumValue = 20
//        temp.addTarget(self, action: #selector(sliderValueChange(_:)), for: UIControl.Event.valueChanged)
//        return temp
//    }()

    
    // 上下文是线程安全的
    // 创建基于 CPU 的 CIContext 对象 (默认是基于 GPU，CPU 需要额外设置参数)
    let ciContext: CIContext = CIContext(options: [CIContextOption.useSoftwareRenderer : true])
    // 创建基于 GPU 的 CIContext 对象
//    let ciContext: CIContext = CIContext(options: nil)

    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.bottom.right.equalToSuperview().offset(-16)
        }
        
        
        // 查看系统滤镜名称
//        let filterNames = CIFilter.filterNames(inCategory: kCICategoryBuiltIn) as [String]
//        print(filterNames)
        // 队列名字
        let label = "com.conpanyName.queue"
        // 优先级
        let qos = DispatchQoS.default
        // 并发
        let attributes = DispatchQueue.Attributes.concurrent
        // autoreleaseFrequency：自动释放频率，有些列队会在执行完任务之后自动释放，有些是不会自动释放的，需要手动释放。
        let autoreleaseFrequnecy = DispatchQueue.AutoreleaseFrequency.never
        let queue = DispatchQueue(label: label, qos: qos, attributes: attributes, autoreleaseFrequency: autoreleaseFrequnecy, target: nil)
        queue.async {
            self.outputImageWithFilterName("CIGaussianBlur")
//            self.useCustomFilter()
        }
    }

    // MARK: 使用自定义滤镜
    func useCustomFilter() {
        guard let cgImage = UIImage(named:"faye1")?.cgImage else { return }
        let ciImage = CIImage(cgImage: cgImage)
        // CustomFilter 自定义滤镜的类名
        let outputImage = ciImage.applyingFilter("CustomFilter")
        if let cgImage = ciContext.createCGImage(outputImage, from: ciImage.extent) {
            let image = UIImage(cgImage: cgImage)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }

    // MARK: 添加滤镜 CIGaussianBlur CIMotionBlur
    func outputImageWithFilterName(_ filterName: String) {

        // 1. 将UIImage转换成CIImage
        guard let ciImage = CIImage.init(image: UIImage(named: "faye1")!) else { return }

        // 2. 创建滤镜
        let filter = CIFilter.init(name: filterName)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(25.0, forKey: "inputRadius")

        let pixelFilter = CIFilter(name: "CIPixellate", parameters: [kCIInputImageKey: filter!.outputImage!])
        pixelFilter?.setDefaults()

        // 链式调用
//        let outputImage = ciImage
//            .applyingFilter("CIGaussianBlur", parameters: [kCIInputRadiusKey:5.0])
//            .applyingFilter("CIPixellate")

        guard let outputImage = pixelFilter?.outputImage else { return }

        // OpenGL 提升性能
//        guard let eaglContext = EAGLContext(api: .openGLES2) else { return }
//        let ciContext = CIContext(eaglContext: eaglContext)

        guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else { return }
        let image = UIImage(cgImage: cgImage)
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }

}
