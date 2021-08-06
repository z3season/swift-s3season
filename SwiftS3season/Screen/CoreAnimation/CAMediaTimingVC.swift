//
//  CAMediaTimingVC.swift
//  SwiftS3season
//
//  Created by season on 2021/8/3.
//

import UIKit

// MARK: Duration duration是一个CFTimeInterval的类型
// 可以加速所有的视图动画来进行自动化测试（注意对于在主窗口之外的视图并不会被影响，比如UIAlertview）
//        window?.layer.speed = 100;

// MARK: repeatCount 代表动画重复的迭代次数。
// 如果duration是2，repeatCount设为3.5（三个半迭代），那么完整的动画时长将是7秒
// duration和repeatCount默认都是0。但这不意味着动画时长为0秒，或者0次，这里的0仅仅代表了“默认”，也就是0.25秒和1次，
// MARK: repeatDuration属性，它让动画重复一个指定的时间，而不是指定次数
// MARK: autoreverses 复原到原始位置

// MARK: beginTime 动画开始之前的的延迟时间
// MARK: speed是一个时间的倍数 默认1.0
// MARK: timeOffset和beginTime类似，但是和增加beginTime导致的延迟动画不同，增加timeOffset只是让动画快进到某一点
/*
 beginTime指定了动画开始之前的的延迟时间。这里的延迟从动画添加到可见图层的那一刻开始测量，默认是0（就是说动画会立刻执行）。

 speed是一个时间的倍数，默认1.0，减少它会减慢图层/动画的时间，增加它会加快速度。如果2.0的速度，那么对于一个duration为1的动画，实际上在0.5秒的时候就已经完成了。

 timeOffset和beginTime类似，但是和增加beginTime导致的延迟动画不同，增加timeOffset只是让动画快进到某一点，例如，对于一个持续1秒的动画来说，设置timeOffset为0.5意味着动画将从一半的地方开始。

 和beginTime不同的是，timeOffset并不受speed的影响。所以如果你把speed设为2.0，把timeOffset设置为0.5，那么你的动画将从动画最后结束的地方开始，因为1秒的动画实际上被缩短到了0.5秒。然而即使使用了timeOffset让动画从结束的地方开始，它仍然播放了一个完整的时长，这个动画仅仅是循环了一圈，然后从头开始播放。
 */

// MARK: fillMode
/*
 默认是removed，当动画不再播放的时候就显示图层模型指定的值。剩下的三种类型分别为向前，向后或者既向前又向后去填充动画状态，使得动画在开始前或者结束后仍然保持开始和结束那一刻的值。

 当用它来解决这个问题的时候，需要把removeOnCompletion设置为false，另外需要给动画添加一个非空的键，于是可以在不需要动画的时候把它从图层上移除。

 extension CAMediaTimingFillMode {
 // 停留在动画结束位置
     public static let forwards: CAMediaTimingFillMode
 // 停留在初始位置
     public static let backwards: CAMediaTimingFillMode
     public static let both: CAMediaTimingFillMode
     public static let removed: CAMediaTimingFillMode
 }
 
 */

// MARK: 贝塞尔曲线理解https://www.cnblogs.com/fangsmile/articles/11642607.html

class CAMediaTimingVC: BaseViewController {

    var bezierPath: UIBezierPath = {
        let curvePath = UIBezierPath.init()
        curvePath.move(to: CGPoint(x: 50, y: 150))
//        curvePath.addCurve(to: CGPoint(x: 300, y: 150), controlPoint1: CGPoint(x: 75, y: 0), controlPoint2: CGPoint(x: 225, y: 300))
        
//        CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
//        //get control points
//        CGPoint controlPoint1, controlPoint2;
//        [function getControlPointAtIndex:1 values:(float *)&controlPoint1];
//        [function getControlPointAtIndex:2 values:(float *)&controlPoint2];
        let function: CAMediaTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        var controlPoint1: [Float] = [0,0]
        var controlPoint2: [Float] = [0,0]
        function.getControlPoint(at: 1, values: &controlPoint1)
        function.getControlPoint(at: 2, values: &controlPoint2)
        
        curvePath.addCurve(to: CGPoint(x: 200, y: 300), controlPoint1: CGPoint(x: CGFloat(controlPoint1[0]), y: CGFloat(controlPoint1[1])), controlPoint2: CGPoint(x: CGFloat(controlPoint2[0]), y: CGFloat(controlPoint2[1])))

//        curvePath.addQuadCurve(to: CGPoint(x: CGFloat(controlPoint1[0]), y: CGFloat(controlPoint1[1])), controlPoint: CGPoint(x: CGFloat(controlPoint2[0]), y: CGFloat(controlPoint2[1])))
        
        curvePath.apply(CGAffineTransform(scaleX: 1.5, y: 1.5))
        return curvePath
    }()
    let shipLayer: CALayer = {
        let layer = CALayer.init()
        layer.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        layer.position = CGPoint(x: 50, y: 150)
        layer.contents = UIImage(named: "car")?.cgImage
        return layer
    }()
    
    var layer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = RANDOM_COLOR().cgColor
        layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.position = CGPoint(x: 100, y: 400)
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.addSublayer(self.shipLayer)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = self.bezierPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = RANDOM_COLOR().cgColor
        shapeLayer.lineWidth = 3
        self.view.layer.addSublayer(shapeLayer)
        
        let btn = UIButton(type: .contactAdd);
        btn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside);
        btn.layer.position = CGPoint(x: 100, y: 400)
        self.view.addSubview(btn)
        self.view.layer.addSublayer(self.layer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        CATransaction.begin()
//        CATransaction.setAnimationDuration(1.0)
//        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeOut))
//        let point = ((touches as NSSet).anyObject() as! UITouch).location(in: self.view)
//        self.layer.position = point
//        CATransaction.commit()

        // 动画缓冲
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [.calculationModeLinear, .calculationModeDiscrete, .calculationModeCubicPaced] ) {
            let point = ((touches as NSSet).anyObject() as! UITouch).location(in: self.view)
            self.layer.position = point
        } completion: { (finish) in }

        
    }
    
    @objc func btnClicked() {
        let keyframeAnimation: CAKeyframeAnimation = CAKeyframeAnimation()
        keyframeAnimation.keyPath = "position"
        keyframeAnimation.timeOffset = 0
        keyframeAnimation.speed = 1
        keyframeAnimation.duration = 2.0
//        keyframeAnimation.autoreverses = true
        keyframeAnimation.fillMode = .forwards
        keyframeAnimation.path = self.bezierPath.cgPath
        keyframeAnimation.rotationMode = .rotateAuto
        keyframeAnimation.isRemovedOnCompletion = false
        self.shipLayer.add(keyframeAnimation, forKey: "slider")
    }
    
}

// MARK: 自由落体 关键帧动画
class BallAnimation: BaseViewController {
    
    var ballView: UIView = {
       let v = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        v.backgroundColor = RANDOM_COLOR()
        v.layer.cornerRadius = 20
        v.layer.masksToBounds = true
        return v
    }()
    
    var timer: CADisplayLink?
    var lastStep: CFTimeInterval = 0.0
    var duration: CFTimeInterval = 1.0
    var timeOffset: CFTimeInterval = 0.0
    var fromValue: AnyObject?
    var toValue: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(ballView)
        antoAnimate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.antoAnimate()
    }
    
    @objc func step(timer: CADisplayLink) {
        let thisStep = CACurrentMediaTime()
        let stepDuration = thisStep - self.lastStep
        self.lastStep = thisStep
        self.timeOffset = min(self.timeOffset + stepDuration, self.duration);

        var time = self.timeOffset / self.duration
        time = CFTimeInterval(self.bounceEaseOut(CGFloat(time)))
        
        let position = self.interpolateValue(self.fromValue as! NSValue, self.toValue as! NSValue, CGFloat(time))
        
        self.ballView.center = position.cgPointValue
        if (self.timeOffset >= self.duration) {
            self.timer?.invalidate()
            self.timer = nil;
        }
    }
    
    
    // MARK: 关键帧自动化
    func antoAnimate() {
        self.ballView.center = CGPoint(x: 150, y: 32)
        self.timeOffset = 0.0
        self.duration = 1.0
        self.lastStep = CACurrentMediaTime()
        self.fromValue = NSValue(cgPoint: CGPoint(x: 150, y: 32))
        self.toValue = NSValue(cgPoint: CGPoint(x: 150, y: 268))
        self.timer?.invalidate()
        self.timer =  CADisplayLink(target: self, selector: #selector(step(timer:)))
        self.timer?.add(to: RunLoop.main, forMode: .default)
        
//        let fromValue = NSValue(cgPoint: CGPoint(x: 150, y: 32))
//        let toValue = NSValue(cgPoint: CGPoint(x: 150, y: 268))
//        let duration: CFTimeInterval = 1.0
//        let numFrames: Int = Int(duration * 60)
//        var frames: [AnyObject] = []
//        for i in 0..<numFrames {
//            var time = Float(1 * i) / Float(numFrames)
//            time = Float(self.bounceEaseOut(CGFloat(time)))
//            frames.append(self.interpolateValue(fromValue, toValue, CGFloat(time)))
//        }
//
//        let keyframeAnimation = CAKeyframeAnimation()
//        keyframeAnimation.keyPath = "position"
//        keyframeAnimation.duration = 1.0
//        keyframeAnimation.values = frames
//        self.ballView.layer.position = CGPoint(x: 150, y: 268)
//        self.ballView.layer.add(keyframeAnimation, forKey: nil)
    }
    
    // http://robertpenner.com/easing/ 一些动画函数
    func bounceEaseOut(_ t: CGFloat) -> CGFloat {
        if (t < 4/11.0) {
            return (121 * t * t)/16.0;
        } else if (t < 8/11.0) {
            return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
        } else if (t < 9/10.0) {
            return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
        }
        return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
    }
    
    func interpolate(_ from: CGFloat, _ to: CGFloat, _ time: CGFloat) -> CGFloat {
        return (to - from) * time + from
    }
    
    func interpolateValue(_ fromValue: AnyObject, _ toValue: AnyObject, _ time: CGFloat) ->  AnyObject {
        if fromValue.isKind(of: NSValue.classForCoder()) {
            let type = fromValue.objCType
            // 判断value类型是否为CGPoint类型
            if (strcmp(type, NSValue(cgPoint: CGPoint(x: 0, y: 0)).objCType) == 0) {
                let from = fromValue.cgPointValue!
                let to = toValue.cgPointValue!
                let result = CGPoint(x: self.interpolate(from.x, to.x, time), y: self.interpolate(from.y, to.y, time))
                return NSValue(cgPoint: result)
            }
        }
        return time < 0.5 ? fromValue : toValue
    }
        
    
    // MARK: 手写关键帧
    func animate() {
        self.ballView.center = CGPoint(x: 150, y: 32)
        let keyframeAnimation = CAKeyframeAnimation()
        keyframeAnimation.keyPath = "position"
        keyframeAnimation.duration = 2.0
        keyframeAnimation.values = [
            NSValue(cgPoint: CGPoint(x: 150, y: 32)),
            NSValue(cgPoint: CGPoint(x: 150, y: 268)),
            NSValue(cgPoint: CGPoint(x: 150, y: 240)),
            NSValue(cgPoint: CGPoint(x: 150, y: 268)),
            NSValue(cgPoint: CGPoint(x: 150, y: 250)),
            NSValue(cgPoint: CGPoint(x: 150, y: 268)),
            NSValue(cgPoint: CGPoint(x: 150, y: 258)),
            NSValue(cgPoint: CGPoint(x: 150, y: 268))
        ]
        keyframeAnimation.timingFunctions = [
            CAMediaTimingFunction(name: .easeIn),
            CAMediaTimingFunction(name: .easeOut),
            CAMediaTimingFunction(name: .easeIn),
            CAMediaTimingFunction(name: .easeOut),
            CAMediaTimingFunction(name: .easeIn),
            CAMediaTimingFunction(name: .easeOut),
            CAMediaTimingFunction(name: .easeIn),
            CAMediaTimingFunction(name: .easeOut)
        ]
                
        keyframeAnimation.keyTimes = [0.0, 0.3, 0.5, 0.7, 0.8, 0.9, 0.95, 1.0]
        self.ballView.layer.position = CGPoint(x: 150, y: 268)
        self.ballView.layer.add(keyframeAnimation, forKey: nil)

    }
    
}
