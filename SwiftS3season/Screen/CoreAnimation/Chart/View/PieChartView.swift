//
//  PieChartView.swift
//  SwiftS3season
//
//  Created by mula on 2021/8/5.
//

import UIKit
import Toast_Swift

class PieChartView: UIControl {
    
    var outPieArray: [CAShapeLayer] = []
    var inPieArray: [CAShapeLayer] = []
    var durationArray: [CFTimeInterval] = []
    var arcArray: [CALayer] = []

    // 外圆半径
    var outRadius: CGFloat = 20.0
    var outPieWidth: CGFloat = 30.0
    // 内圆半径
    var inRadius: CGFloat = 10.0
    var inPieWidth: CGFloat = 10.0
    // 圆心
    var pieCenter: CGPoint = CGPoint(x: 0, y: 0)
    
    let padding: CGFloat = 10.0
    
    var pieModelArray: [PieModel] = []
    let maxValue = CGFloat.pi * 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#fafafa")
        let totalPi = CGFloat.pi * 2
        self.pieModelArray = [
            PieModel(angle: totalPi * 0.1, alpha: 0.6, desc: "第一个弧形"),
            PieModel(angle: totalPi * 0.3, alpha: 0.9, desc: "第二个弧形"),
            PieModel(angle: totalPi * 0.2, alpha: 0.8, desc: "第三个弧形"),
            PieModel(angle: totalPi * 0.15, alpha: 1, desc: "第四个弧形"),
            PieModel(angle: totalPi * 0.25, alpha: 0.5, desc: "第五个弧形"),
        ]
        self.drawPieChart()
    }
        
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dealTouchHandle(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.dealTouchHandle(touches: touches)
    }
    
    func dealTouchHandle(touches: Set<UITouch>) {
        let set: NSSet = touches as NSSet;
        let touchPoint: CGPoint = (set.anyObject() as! UITouch).location(in: self)
        // 圆心与点击位置 与x轴的角度
        let touchAngle = self.calculateAngle(startPoint: self.pieCenter, endPoint: touchPoint)
        
//        let a = RADIANS_TO_DEGREES(touchAngle)
//        print("当前点击的角度 \(a)")
        
        // 圆心到点击位置的距离
        let touchDistance = self.calculateDistanceBetweenTwoPoints(touchPoint, self.pieCenter)
        // 点击了内圆
        if touchDistance < (self.inRadius - self.inPieWidth * 0.5) {
//            self.makeToast("点击了内圆")
            return;
        }
        // 点击了圆环
        if touchDistance < (self.outPieWidth * 0.5 + self.outRadius) {
            for (index, model) in pieModelArray.enumerated() {
                if model.startAngle < touchAngle && model.endAngle > touchAngle {
//                    self.makeToast("点击了圆环\(model.desc)--- 角度\(model.angleNum)")
                    self.selectedArc(index)
                    break
                }
            }
            return;
        }
    }
    
    // MARK: 点击了一个弧
    func selectedArc(_ index: Int) {
        if index < 0 || index >= self.pieModelArray.count {
            return
        }
        var preIndex: Int?
        for (idx, item) in pieModelArray.enumerated() {
            if item.isMoveOut {
                preIndex = idx
                break
            }
        }
        let currentModel = self.pieModelArray[index]
        guard preIndex != nil || preIndex == index else {
            currentModel.isMoveOut = !currentModel.isMoveOut
            let currentLayer = self.arcArray[index]
            currentLayer.transform = currentModel.transform()
            return
        }
        currentModel.isMoveOut = true

        let preModel = self.pieModelArray[preIndex ?? 0]
        preModel.isMoveOut = false
        
        let currentLayer = self.arcArray[index]
        currentLayer.transform = currentModel.transform()
        let preLayer = self.arcArray[preIndex ?? 0]
        preLayer.transform = preModel.transform()
    }
  
    // MARK: 绘制内外圆
    func drawPieChart() {
        let height = self.frame.height
        let width = self.frame.width
        self.outRadius = 90
        self.inRadius = 60
        self.outPieWidth = 45
        self.inPieWidth = ((self.outRadius - self.inRadius - self.outPieWidth * 0.5) * 2)
        self.pieCenter = CGPoint(x: width / 2.0, y: height / 2.0)
        
        var outPieArray: [CAShapeLayer] = []
        var inPieArray: [CAShapeLayer] = []
        // 动画时间, 每一段的动画时间应该跟它所占比成比例
        var durationArray: [CFTimeInterval] = []
        // 容器 动画时方便整体移动
        var arcArray: [CALayer] = []
        // 起始角度
        var endAngle: CGFloat = -(CGFloat.pi / 2)
        
        for (_, model) in self.pieModelArray.enumerated() {
            
            //创建一个容器 外部饼状图与内部饼状图
            let arcLayer = CALayer()
            arcLayer.isDoubleSided = false
            arcLayer.frame = self.bounds
            arcArray.append(arcLayer)
            self.layer.addSublayer(arcLayer)
            
            // 计算起始、终止角度
            let startAngle = endAngle
            endAngle = model.angle + startAngle
            model.startAngle = startAngle
            model.endAngle = endAngle
            
            // 1.2是总共的动画时间, 计算这一块动画所需要的时间
            let duration = 1.2
//                CFTimeInterval(1.2 * model.totalGiftValue / maxValue)
            durationArray.append(duration)
            
            // 当前饼状图的颜色
            let color = RANDOM_COLOR()
            let outColor = color.withAlphaComponent(model.alpha)
            let inColor = color.withAlphaComponent(model.alpha * 0.5)
            
            let outPiePath = UIBezierPath()
            let inPiePath = UIBezierPath()
            
            // 画弧形
            outPiePath.addArc(withCenter: self.pieCenter, radius: self.outRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            inPiePath.addArc(withCenter: self.pieCenter, radius: self.inRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            let outLayer = CAShapeLayer()
            outLayer.path = outPiePath.cgPath
            outLayer.lineWidth = self.outPieWidth
            outLayer.strokeColor = outColor.cgColor;
            outLayer.fillColor = UIColor.clear.cgColor;
//            outLayer.isHidden = true
            arcLayer.addSublayer(outLayer)

            let inLayer = CAShapeLayer()
            inLayer.path = inPiePath.cgPath
            inLayer.lineWidth = self.inPieWidth
            inLayer.strokeColor = inColor.cgColor;
            inLayer.fillColor = UIColor.clear.cgColor;
//            inLayer.isHidden = true
            arcLayer.addSublayer(inLayer)

            outPieArray.append(outLayer)
            inPieArray.append(inLayer)
        }
        self.outPieArray = outPieArray
        self.inPieArray = inPieArray
        self.durationArray = durationArray
        self.arcArray = arcArray
    }
    
    // MARK: 计算两点与y轴的角度
    func calculateAngle(startPoint: CGPoint, endPoint: CGPoint) -> CGFloat {
        let xPoint = CGPoint(x: startPoint.x + (self.outRadius - self.outPieWidth * 0.5), y: startPoint.y)
        let a = endPoint.x - startPoint.x
        let b = endPoint.y - startPoint.y
        let c = (xPoint.x - startPoint.x)
        let d = (xPoint.y - startPoint.y)
        let e = a * c + b * d
        let f = sqrt(a * a + b * b)
        let g = sqrt(c * c + d * d)
        // 角度
        var rads = acos(e / (f * g))
        if (startPoint.y > endPoint.y) {
            rads = -rads;
        }
        if (rads < -CGFloat.pi * 0.5 && rads > -CGFloat.pi) {
            rads += CGFloat.pi * 2;
        }
        return rads
    }
    
    // MARK: 计算两点的距离
    func calculateDistanceBetweenTwoPoints(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let width = abs(a.x - b.x)
        let height = abs(a.y - b.y)
        return sqrt(width * width + height * height)
    }
    
}
