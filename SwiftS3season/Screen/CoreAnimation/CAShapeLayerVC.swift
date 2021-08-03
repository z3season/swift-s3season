//
//  CAShapeLayerVC.swift
//  SwiftS3season
//
//  Created by mula on 2021/8/2.
//

import UIKit
import QuartzCore

class CAShapeLayerVC: BaseViewController {

    var szLayerView: UIView = {
        let layer = UIView.init()
        layer.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        return layer
    }()
    var szLayer: CALayer = {
        let layer = CALayer.init()
        layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.backgroundColor = RANDOM_COLOR().cgColor
        return layer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: CATransition
        // 行为通常是一个被Core Animation隐式调用的显式动画对象。这里我们使用的是一个实现了CATransition的实例，叫做推进过渡
        // CATransition响应CAAction协议，并且可以当做一个图层行为就足够了。
        // 不论在什么时候改变背景颜色，新的色块都是从左侧滑入，而不是默认的渐变效果
        let cATransition: CATransition = CATransition()
        cATransition.type = .push
        cATransition.subtype = .fromLeft
        self.szLayer.actions = ["backgroundColor": cATransition]

        self.szLayer.position = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.size.height / 2)

        self.view.addSubview(self.szLayerView)
        self.szLayerView.layer.addSublayer(self.szLayer)
        let btn = UIButton.init(type: .system)
        btn.frame = CGRect(x: 100, y: 50, width: 100, height: 30)
        btn.backgroundColor = RANDOM_COLOR()
        btn.addTarget(self, action: #selector(changeColor), for: .touchUpInside)
        btn.setTitle("修改颜色", for: .normal)
        self.view.addSubview(btn)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let set: NSSet = touches as NSSet;
        let superPoint: CGPoint = ((touches as NSSet).anyObject() as! UITouch).location(in: self.view)
        let point = self.szLayer.convert(superPoint, from: self.view.layer)
        if ((self.szLayer.presentation()?.hitTest(point)) != nil) {
            self.szLayer.backgroundColor = RANDOM_COLOR().cgColor
        } else {
            CATransaction.begin()
            CATransaction.setAnimationDuration(1.5)
            self.szLayer.position = superPoint
            CATransaction.commit()
        }
    }
    
    @objc func changeColor() {
        // 修改颜色
        self.szLayer.backgroundColor = RANDOM_COLOR().cgColor
    }
    
    @objc func changeColor1() {
        // MARK: CATransaction
        // 事务是通过CATransaction类来做管理，这个类的设计有些奇怪，不像你从它的命名预期的那样去管理一个简单的事务，
        // 而是管理了一叠你不能访问的事务。CATransaction没有属性或者实例方法，
        // 并且也不能用+alloc和-init方法创建它。而是用类方法+begin和+commit分别来入栈或者出栈。

        // 我们当然可以用当前事务的+setAnimationDuration:方法来修改动画时间，但在这里我们首先起一个新的事务，
        // 于是修改时间就不会有别的副作用。因为修改当前事务的时间可能会导致同一时刻别的动画（如屏幕旋转），
        // 所以最好还是在调整动画之前压入一个新的事务。

        // UIView直接通过返回nil来禁用隐式动画
        print(self.szLayerView.action(for: self.szLayer, forKey: "backgroundColor")!)

        // 开始一个事务
        CATransaction.begin()
        
        // 如果在动画块范围之内，根据动画具体类型返回相应的属性，在这个例子就是CABasicAnimation
        print(self.szLayerView.action(for: self.szLayer, forKey: "backgroundColor")!)
        
        // 设置动画时间 默认的事务时间为0.25秒
        CATransaction.setAnimationDuration(1.0)
        // 当前事务完成后回调
        CATransaction.setCompletionBlock {
            // CGAffineTransform 二维平面的缩放 平移 旋转
            var transform: CGAffineTransform = self.szLayer.affineTransform()
            transform = transform.rotated(by: CGFloat.pi / 2)
            self.szLayer.setAffineTransform(transform)
        }
        
        // 禁止动画
//        CATransaction.setDisableActions(true)
        // 修改颜色
        self.szLayer.backgroundColor = RANDOM_COLOR().cgColor
        // 提交事务
        CATransaction.commit()
        
        // UIView有两个方法，+beginAnimations:context:和+commitAnimations，和CATransaction的+begin和+commit方法类似。
        // 实际上在+beginAnimations:context:和+commitAnimations之间所有视图或者图层属性的改变而做的动画都是由于设置了CATransaction的原因
    }

}

/**
 CAShapeLayer是一个通过矢量图形而不是bitmap来绘制的图层子类。你指定诸如颜色和线宽等属性，用CGPath来定义想要绘制的图形，最后CAShapeLayer就自动渲染出来了。当然，你也可以用Core Graphics直接向原始的CALyer的内容中绘制一个路径，相比之下，使用CAShapeLayer有以下一些优点：

 渲染快速。CAShapeLayer使用了硬件加速，绘制同一图形会比用Core Graphics快很多。
 高效使用内存。一个CAShapeLayer不需要像普通CALayer一样创建一个寄宿图形，所以无论有多大，都不会占用太多的内存。
 不会被图层边界剪裁掉。一个CAShapeLayer可以在边界之外绘制。你的图层路径不会像在使用Core Graphics的普通CALayer一样被剪裁掉
 不会出现像素化。当你把CAShapeLayer放大，或是用3D透视变换将其离相机更近时，它不像一个有寄宿图的普通图层一样变得像素化。
 */
// MARK: CAGradientLayer 创建渐变色
// MARK: CAReplicatorLayer 重复图层
// MARK: CAScrollLayer
/*
 不同于UIScrollView，我们定制的滑动视图类并没有实现任何形式的边界检查（bounds checking）。图层内容极有可能滑出视图的边界并无限滑下去。CAScrollLayer并没有等同于UIScrollView中contentSize的属性，所以当CAScrollLayer滑动的时候完全没有一个全局的可滑动区域的概念，也无法自适应它的边界原点至你指定的值。它之所以不能自适应边界大小是因为它不需要，内容完全可以超过边界。

 那你一定会奇怪用CAScrollLayer的意义到底何在，因为你可以简单地用一个普通的CALayer然后手动适应边界原点啊。真相其实并不复杂，UIScrollView并没有用CAScrollLayer，事实上，就是简单的通过直接操作图层边界来实现滑动。

 CAScrollLayer有一个潜在的有用特性。如果你查看CAScrollLayer的头文件，你就会注意到有一个扩展分类实现了一些方法和属性：
 */
// MARK: CATiledLayer

/*
 有些时候你可能需要绘制一个很大的图片，常见的例子就是一个高像素的照片或者是地球表面的详细地图。iOS应用通畅运行在内存受限的设备上，所以读取整个图片到内存中是不明智的。载入大图可能会相当地慢，那些对你看上去比较方便的做法（在主线程调用UIImage的-imageNamed:方法或者-imageWithContentsOfFile:方法）将会阻塞你的用户界面，至少会引起动画卡顿现象。

 能高效绘制在iOS上的图片也有一个大小限制。所有显示在屏幕上的图片最终都会被转化为OpenGL纹理，同时OpenGL有一个最大的纹理尺寸（通常是2048*2048，或4096*4096，这个取决于设备型号）。如果你想在单个纹理中显示一个比这大的图，即便图片已经存在于内存中了，你仍然会遇到很大的性能问题，因为Core Animation强制用CPU处理图片而不是更快的GPU（见第12章『速度的曲调』，和第13章『高效绘图』，它更加详细地解释了软件绘制和硬件绘制）。

 CATiledLayer为载入大图造成的性能问题提供了一个解决方案：将大图分解成小片然后将他们单独按需载入
 */
