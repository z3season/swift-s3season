//
//  CoreGraphicsVC.swift
//  SwiftS3season
//
//  Created by season on 2021/8/4.
//

import UIKit
import CoreGraphics

// MARK: Core Graphics是Quartz 2D的一个高级绘图引擎，常用与iOS，tvOS，macOS的图形绘制应用开发。Core Graphics是对底层C语言的一个简单封装，其中提供大量的低层次，轻量级的2D渲染API。

/*
 UIKit：最常用的视图框架，封装度最高，都是OC对象
 CoreGraphics：主要绘图系统，常用于绘制自定义视图，纯C的API，使用Quartz2D做引擎
 CoreAnimation：提供强大的2D和3D动画效果
 OpenGL-ES：主要用于游戏绘制，但它是一套编程规范，具体由设备制造商实现
 */

class CoreGraphicsVC: BaseViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 375, height: 30))
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = .black
        label.text = "地方搜金风科技的立法的水立方就能发考了多少分姜女士了发快递"
        self.view.addSubview(label)
        
        let view = CGViewContext.init(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        self.view.addSubview(view)
        let image = UIImage(named: "img_03.jpeg")!
        let grayImg = CGContextImage.spliceImage(image, UIImage(named: "img_02.jpeg")!)
        let imageView = UIImageView(image: grayImg)
        imageView.frame = CGRect(x: 0, y: 0, width: 1080 * 0.2, height: 1920 * 0.2)
        imageView.layer.isDoubleSided = false
        view.addSubview(imageView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let viewImg = CGContextImage.captureView(getKeyWindow())
            // 截图
            let imageV = UIImageView(image: viewImg)
            imageV.layer.borderWidth = 3.0
            imageV.layer.borderColor = RANDOM_COLOR().cgColor
            imageV.frame = CGRect(x: 10, y: 300, width: 100, height: 200)
            self.view.addSubview(imageV)
        }
    }
    
}

class CGContextImage {
    
    // MARK: 灰度图片
    static func grayImage(_ image: UIImage) -> UIImage {
        // 创建灰度色彩空间的对象
        let spaceRef = CGColorSpaceCreateDeviceGray()
        // 创建图形上下文
        /*
            参数1：指向要渲染的绘制内存的地址
            参数2：高度
            参数3：宽度
            参数4：表示内存中像素的每个组件的位数
            参数5：每一行在内存所占的比特数
            参数6：表示上下文使用的颜色空间
            参数7：表示是否包含透明通道
            */
        let imageSize = image.size
        let context = CGContext(data: nil, width: Int(imageSize.width), height: Int(imageSize.height), bitsPerComponent: 8, bytesPerRow: 0, space: spaceRef, bitmapInfo: CGBitmapInfo().rawValue)
        // 然后创建一个和原视图同样尺寸的空间
        let rect = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        // 在灰度上下文中画入图片
        context?.draw(image.cgImage!, in: rect)
        let grayImage = UIImage(cgImage: context!.makeImage()!)
        return grayImage
    }
    
    // MARK: 图片二值化
    static func binarizationImage(_ image: UIImage) -> UIImage {
        // 使用OpenGL的CoreImage实现
        return image
    }
    
    // MARK: 图片拼接
    static func spliceImage(_ image1: UIImage, _ image2: UIImage) -> UIImage {
        
        let size = CGSize(width: image1.size.width, height: image1.size.height)
        // 创建一个基于位图的上下文（context）,并将其设置为当前上下文(context)
        UIGraphicsBeginImageContext(size)

        image1.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image2.draw(in: CGRect(x: 10, y: 10, width: image2.size.width * 0.3, height: image2.size.height * 0.4))

        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
                
        return resultImage ?? image1
    }
    
    // MARK: 页面截图
    static func captureView(_ view: UIView) -> UIImage {
        /*
            参数1：绘制的尺寸大小
            参数2：透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
            参数3：设为0后，系统就会自动设置正确的比例
        */
        // 创建一个基于位图的上下文context
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, UIScreen.main.scale)
        // 渲染view.layer到当前context
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        // 通过context获取UIImage
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}

class CGViewContext: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = RANDOM_COLOR()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.cubicBezierCurve()
    }

    // MARK: 绘制线段
    func line() {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        // 设置线宽
        context.setLineWidth(2.0)
        // 设置起点
        context.move(to: CGPoint(x: 10, y: 20))
        // 第二个点
        context.addLine(to: CGPoint(x: 50, y: 50))
        // 设置颜色
        UIColor.red.set()
        // 渲染
        context.strokePath()
    }
    
    // MARK: 绘制矩形
    func rectangular() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(2.0)
        // 矩形
        context.addRect(CGRect(x: 10, y: 10, width: 30, height: 30))
        UIColor.red.set()
        context.strokePath()
    }
 
    // MARK: 绘制圆
    func round() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(2.0)
        /*
         center：圆心
         radius：半径
         startAngle：开始弧度
         endAngle：结束弧度
         clockwise：绘制方向，NO:顺时针; YES:逆时针
          */
        context.addArc(center: CGPoint(x: 50, y: 50), radius: 30, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        UIColor.red.set()
        context.strokePath()
    }
    
    // MARK: 二次贝塞尔曲线
    func quadraticBezierCurve() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(2.0)
        // 虚线
        context.setLineDash(phase: 0, lengths: [10, 5])
        context.move(to: CGPoint(x: 10, y: 20))
        // to：结束点 control：控制点
        context.addQuadCurve(to: CGPoint(x: 90, y: 80), control: CGPoint(x: 10, y: 80))
        UIColor.red.set()
        context.strokePath()
    }
    
    // MARK: 三次贝塞尔曲线
    func cubicBezierCurve() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(2.0)
        context.move(to: CGPoint(x: 10, y: 20))
        // to：结束点 control1：控制点1 control2：控制点2
        context.addCurve(to: CGPoint(x: 90, y: 80), control1: CGPoint(x: 80, y: 30), control2: CGPoint(x: 10, y: 80))
        UIColor.red.set()
        context.strokePath()
    }
    
}
