//
//  CoreAnimationVC.swift
//  SwiftS3season
//
//  Created by mula on 2021/7/29.
//

import UIKit

class CoreAnimationVC1: BaseViewController, CALayerDelegate {

    let layerView: UIView = {
        let v = UIView(frame: CGRect.zero)
        v.backgroundColor = .gray
        return v
    }()
    let szLayer: CALayer = {
        let l = CALayer.init()
        l.backgroundColor = UIColor.red.cgColor
        return l
    }()
    let myLayer: CALayer = {
        let l = CALayer.init()
        l.frame = CGRect(x: 50, y: 0, width: 2, height: 100)
        l.backgroundColor = UIColor(hex: "#ffdd07").cgColor
        // 必须设置 anchorPoint position才能够使用旋转
        // 自身的旋转点
        l.anchorPoint = CGPoint(x:0.5, y:1.0)
        // 相对于父控件的旋转点
        l.position = CGPoint(x: 100, y: 100)
        return l
    }()

    var timer: Timer?
    var second: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
//        layerCustom()
//        layerView.layer.addSublayer(myLayer)
//        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        
        // 混合变换 组合两个矩阵
//        let a: CGAffineTransform = CGAffineTransform(scaleX: 1, y: 1)
//        a.concatenating(CGAffineTransform(rotationAngle: 1))
        
        view.addSubview(layerView)
        layerView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
            make.center.equalToSuperview()
        }
        let image = UIImage(named: "faye1")
        // contents类型为CGImage CGImage为了兼容macOS的NSView
        layerView.layer.contents = image?.cgImage

        transform3DFunc()
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let set: NSSet = touches as NSSet;
        let superPoint: CGPoint = (set.anyObject() as! UITouch).location(in: self.view)
        let point = self.layerView.layer.convert(superPoint, from: self.view.layer)
        
        // 判断是否点击在self.layerView上
        if self.layerView.layer.contains(point) {
            print("点击在self.layerView contains")
        }
        
        // 注意当调用图层的hitTest方法时，测算的顺序严格依赖于图层树当中的图层顺序（和UIView处理事件类似）。
        // 之前提到的zPosition属性可以明显改变屏幕上图层的顺序，但不能改变触摸事件被处理的顺序。
        // 这意味着如果改变了图层的z轴顺序，你会发现将不能够检测到最前方的视图点击事件，
        // 这是因为被另一个图层遮盖住了，虽然它的zPosition值较小，但是在图层树中的顺序靠前。
        let touchLayer = self.layerView.layer.hitTest(superPoint);
        if touchLayer == self.layerView.layer {
            print("点击在self.layerView hitTest")
        }
        
    }
    
    @objc func tick() {
//        let calendar = NSCalendar.init(identifier: .gregorian)
//        let components = calendar?.components(.second, from: NSDate.now, to: NSDate.distantFuture, options: [])
//        let secsAngle = (Double(components?.second ?? 0) / 60.0) * Double.pi * 2.0;
        self.second += 1.0;
        if self.second > 60.0 {
            self.second = 0.0
        }
        let angle = (self.second * CGFloat.pi * 2 / 60)
        print(angle)
        self.myLayer.setAffineTransform(CGAffineTransform(rotationAngle: angle))
    }
    
    // MARK: CATransform3D
    func transform3DFunc() {
        var transform3D = CATransform3DIdentity
        // MARK: m34用于按比例缩放X和Y的值来计算到底要离视角多远。
        // m34负责z轴方向的translation（移动），m34= -1/D,  默认值是0，也就是说D无穷大，这意味投射面和layer in world coordinate重合了。D越小透视效果越明显。 所谓的D，是eye（观察者）到投射面的距离。
        transform3D.m34 = -1.0 / 500.0
        // 沿着y轴旋转45°
        transform3D = CATransform3DRotate(transform3D, CGFloat.pi / 4, 0, 1, 0)
        self.layerView.layer.transform = transform3D
        /*
         sublayerTransform属性
         如果有多个视图或者图层，每个都做3D变换，那就需要分别设置相同的m34值，并且确保在变换之前都在屏幕中央共享同一个position，如果用一个函数封装这些操作的确会更加方便，但仍然有限制（例如，你不能在Interface Builder中摆放视图），这里有一个更好的方法。

         CALayer有一个属性叫做sublayerTransform。它也是CATransform3D类型，但和对一个图层的变换不同，它影响到所有的子图层。这意味着你可以一次性对包含这些图层的容器做变换，于是所有的子图层都自动继承了这个变换方法。
         */
        
        // 表示图层背面是否绘制  默认YES z轴旋转时可看到图片镜像
        self.layerView.layer.isDoubleSided = true
        
    }
    
    // MARK: layer的一些属性
    func layerCustom() {
        
        // iOS一个图层的position位于父图层的左上角，但是在Mac OS上，通常是位于左下角。Core Animation可以通过geometryFlipped属性来适配这两种情况，
        // 它决定了一个图层的坐标是否相对于父图层垂直翻转，是一个BOOL类型。
        // 在iOS上通过设置它为YES意味着它的子图层将会被垂直翻转，也就是将会沿着底部排版而不是通常的顶部
//        layerView.layer.isGeometryFlipped = true
        
        // 对应contentsGravity
        /*
         kCAGravityCenter
         kCAGravityTop
         kCAGravityBottom
         kCAGravityLeft
         kCAGravityRight
         kCAGravityTopLeft
         kCAGravityTopRight
         kCAGravityBottomLeft
         kCAGravityBottomRight
         kCAGravityResize
         kCAGravityResizeAspect
         kCAGravityResizeAspectFill
         */
        // 下面两个效果一致
//        layerView.contentMode = .scaleAspectFit
        layerView.layer.contentsGravity = .resizeAspect
        // contentsScale 属性其实属于支持高分辨率（又称Hi-DPI或Retina）屏幕机制的一部分
        /**
         如果contentsScale设置为1.0，将会以每个点1个像素绘制图片，如果设置为2.0，则会以每个点2个像素绘制图片，这就是我们熟知的Retina屏幕。
         
         用代码的方式来处理寄宿图的时候，一定要记住要手动的设置图层的contentsScale属性，否则，你的图片在Retina设备上就显示得不正确
         */
        layerView.layer.contentsScale = UIScreen.main.scale
        
        // masksToBounds 类似于clipsToBounds 超出边界裁剪
        layerView.layer.masksToBounds = true
     
        // contentsRect 默认 {0, 0, 1, 1} 坐标系 跟锚点类似 左上角 0 0  显示大图的部分坐标位置的图
//        layerView.layer.contentsRect = CGRect(x: 0, y: 0, width: 0.5, height: 0.5)
        /*
         - (void)addSpriteImage:(UIImage *)image withContentRect:(CGRect)rect ￼toLayer:(CALayer *)layer //set image
         {
           layer.contents = (__bridge id)image.CGImage;

           //scale contents to fit
           layer.contentsGravity = kCAGravityResizeAspect;

           //set contentsRect
           layer.contentsRect = rect;
         }

         - (void)viewDidLoad
         {
           [super viewDidLoad]; //load sprite sheet
           UIImage *image = [UIImage imageNamed:@"Sprites.png"];
           //set igloo sprite
           [self addSpriteImage:image withContentRect:CGRectMake(0, 0, 0.5, 0.5) toLayer:self.iglooView.layer];
           //set cone sprite
           [self addSpriteImage:image withContentRect:CGRectMake(0.5, 0, 0.5, 0.5) toLayer:self.coneView.layer];
           //set anchor sprite
           [self addSpriteImage:image withContentRect:CGRectMake(0, 0.5, 0.5, 0.5) toLayer:self.anchorView.layer];
           //set spaceship sprite
           [self addSpriteImage:image withContentRect:CGRectMake(0.5, 0.5, 0.5, 0.5) toLayer:self.shipView.layer];
         }
         */
        
        // 定义了图层中的可拉伸区域和一个固定的边框。 改变contentsCenter的值并不会影响到寄宿图的显示，除非这个图层的大小改变了，你才看得到效果。
//        layerView.layer.contentsCenter = CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5)
        
        szLayer.frame = CGRect(x: 50, y: 50, width: 100, height: 50)
        layerView.layer.addSublayer(szLayer)
        szLayer.delegate = self
        szLayer.backgroundColor = UIColor.blue.cgColor
        szLayer.display()
    }
    
    // MARK: CALayerDelegate 在layer上绘制图形
    func draw(_ layer: CALayer, in ctx: CGContext) {
        ctx.setLineWidth(10.0)
        ctx.setStrokeColor(UIColor.red.cgColor)
        ctx.strokeEllipse(in: layer.bounds);
    }

}
