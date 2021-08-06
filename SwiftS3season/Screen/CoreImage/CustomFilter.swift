//
//  CustomFilter.swift
//  SwiftS3season
//
//  Created by season on 2021/7/29.
//

import UIKit


// 参考
// https://www.cnblogs.com/kenshincui/p/12181735.html
// http://colin1994.github.io/2016/10/21/Core-Image-Custom-Filter/

// MARK: 自定义滤镜
/*
 分三步：
 1，编写 CIKernel：使用 CIKL，自定义滤镜效果。
 2，加载 CIKernel：CIFilter 读取编写好的 CIKernel。
 3，设置参数：设置 CIKernel 需要的输入参数以及 DOD 和 ROI。
 */

/*
 CIKernel 是我们 Filter 对应的脚本，它描述 Filter 的具体工作原理。
 CIKL （Core Image Kernel Language）是编写 CIKernel 的语言。
 DOD，ROI 当做普通的参数处理。
 */

//class CustomFilterGenerator:NSObject, CIFilterConstructor {
//    func filter(withName name: String) -> CIFilter? {
//        if name == "\(CustomFilter.self)" {
//            return CustomFilter()
//        }
//        return nil
//    }
//}

//private var pixellateKernel:CIWarpKernel? = {
//    guard let url = Bundle.main.url(forResource: "default", withExtension: "metallib") else { return nil }
//    guard let data = try? Data(contentsOf: url) else { return nil }
//    let kernel = try? CIWarpKernel(functionName: "pixellateMetal", fromMetalLibraryData: data)
//    return kernel
//}()
//
//class CustomFilter: CIFilter {
//
//    override init() {
//        super.init()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    static func register() {
//        CIFilter.registerName("\(CustomFilter.self)", constructor: CustomFilterGenerator(), classAttributes: [kCIAttributeFilterName:"\(CustomFilter.self)"])
//    }
//
//    override func setDefaults() {
//
//    }
//
//    @objc var inputImage: CIImage?
//
//    @objc var radius:CGFloat = 5.0
//
//    override var outputImage: CIImage? {
//        let result = pixellateKernel?.apply(extent: inputImage!.extent, roiCallback: { (index, rect) -> CGRect in
//            return rect
//        }, image: self.inputImage!, arguments: [radius])
//        return result
//    }
//
//    override var name: String {
//        get {
//            return "\(CustomFilter.self)"
//        }
//        set {
//
//        }
//    }
//
//    override var attributes: [String : Any] {
//        get {
//            return [
//                "radius":[
//                    kCIAttributeMin:1,
//                    kCIAttributeDefault:5.0,
//                    kCIAttributeType:kCIAttributeTypeScalar
//                ]
//            ]
//        }
//    }
//}


class CustomFilterGenerator: NSObject, CIFilterConstructor {
    func filter(withName name: String) -> CIFilter? {
        if name == "\(CustomFilter.self)" {
            return CustomFilter()
        }
        return nil
    }
}

private let flipKernel: CIWarpKernel? = CIWarpKernel(source:try! String(contentsOf:Bundle.main.url(forResource: "MirrorX", withExtension: "cikernel")!))

class CustomFilter: CIFilter {

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func register() {
        CIFilter.registerName("\(CustomFilter.self)", constructor: CustomFilterGenerator(), classAttributes: [kCIAttributeFilterName:"\(CustomFilter.self)"])
    }

    override func setDefaults() {

    }

    @objc var inputImage: CIImage?

    override var outputImage: CIImage? {
        guard let width = self.inputImage?.extent.size.width else { return nil }
        /*
         extent:要处理的输入图片的区域(称之为DOD ( domain of definition ) )，一般处理的都是原图，并不会改变图像尺寸所以上面传的是inputImage.extent
         roiCallback:感兴趣的处理区域（ROI ( region of interest )，可以理解为当前处理区域对应的原图区域）处理完后的回调，回调参数index代表图片索引顺序，回调参数rect代表输出图片的区域DOD，但是需要注意在Core Image处理中这个回调会多次调用。这个值通常只要不发生旋转就是当前图片的坐标（如果旋转90°，则返回为CGRect(x: rect.origin.y, y: rect.origin.x, width: rect.size.height, height: rect.size.width)）
         arguments:着色器函数中需要的参数，按顺序传入。
         */
        let result = flipKernel?.apply(extent: inputImage!.extent, roiCallback: { (index, rect) -> CGRect in
            return rect
        }, image: self.inputImage!, arguments: [width])
        return result
    }

    override var name: String {
        get {
            return "\(CustomFilter.self)"
        }
        set {

        }
    }

}
