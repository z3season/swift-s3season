//
//  GraphView.swift
//  SwiftS3season
//
//  Created by season on 2021/8/5.
//

import UIKit

// MARK: 曲线图
class GraphView: UIView {
    
    private var curveLayer: CAShapeLayer?
    private var gradientLayer: CAGradientLayer?
    private var gradientPath: UIBezierPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#fafafa")
        let width = self.frame.width
        let height = self.frame.height
        drawLayer(pointArray: [
            CGPoint(x: 0, y: height),
            CGPoint(x: 30, y: height - 30),
            CGPoint(x: 50, y: height - 50),
            CGPoint(x: 80, y: height - 80),
            CGPoint(x: 100, y: height - 100),
            CGPoint(x: 120, y: height - 80),
            CGPoint(x: 150, y: height - 50),
            CGPoint(x: 180, y: height - 100),
            CGPoint(x: 200, y: height - 50),
            CGPoint(x: 260, y: 50),
            CGPoint(x: width, y: height - 30),
        ])
        self.curveLayer?.isHidden = true
        self.gradientLayer?.isHidden = true
        self.startCurveAnimation()
        coordinateSystem()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: 绘制坐标系
    func coordinateSystem() {
        let xLinePath = UIBezierPath()
        xLinePath.lineWidth = 2.0
        xLinePath.move(to: CGPoint(x: 0, y: self.frame.height))
        xLinePath.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        
        let xLineLayer = CAShapeLayer()
        xLineLayer.strokeColor = UIColor(hex: "#666666").cgColor
        xLineLayer.path = xLinePath.cgPath
        self.layer.addSublayer(xLineLayer)
        
        let yLinePath = UIBezierPath()
        yLinePath.lineWidth = 2.0
        yLinePath.move(to: CGPoint(x: 0, y: 0))
        yLinePath.addLine(to: CGPoint(x: 0, y: self.frame.height))
        
        let yLineLayer = CAShapeLayer()
        yLineLayer.strokeColor = UIColor(hex: "#666666").cgColor
        yLineLayer.path = yLinePath.cgPath
        self.layer.addSublayer(yLineLayer)
    }
    
    // MARK: 绘制曲线图
    func drawLayer(pointArray: [CGPoint]) {
        // 渐变色路径
        let gradientPath = UIBezierPath()
        // 曲线路径
        let curvePath = UIBezierPath()
        // 记录上一个点
        var lastPoint: CGPoint = CGPoint.zero
        // 上一个点的索引
        var lastIdx: Int = 0
        // 渐变色移动到左下角
        gradientPath.move(to: CGPoint(x: 0, y: self.frame.height))
        // 遍历所有点, 移动Path绘制图形
        for (index, currentPoint) in pointArray.enumerated() {
            if index == 0 {
                gradientPath.addLine(to: currentPoint)
                curvePath.move(to: currentPoint)
                lastPoint = currentPoint
                lastIdx = index
            } else if ((index == pointArray.count - 1) || currentPoint.y == 0 || (lastIdx + 1 == index)) {
                // 三次曲线
                gradientPath.addCurve(to: currentPoint, controlPoint1: CGPoint(x: (lastPoint.x + currentPoint.x) / 2, y: lastPoint.y), controlPoint2: CGPoint(x: (lastPoint.x + currentPoint.x) / 2, y: currentPoint.y))
                curvePath.addCurve(to: currentPoint, controlPoint1: CGPoint(x: (lastPoint.x + currentPoint.x) / 2, y: lastPoint.y), controlPoint2: CGPoint(x: (lastPoint.x + currentPoint.x) / 2, y: currentPoint.y))
                lastPoint = currentPoint
                lastIdx = index
            }
        }
        gradientPath.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        gradientPath.addLine(to: CGPoint(x: 0, y: self.frame.height))
        
        let gradientLayer = CAShapeLayer()
        gradientLayer.path = gradientPath.cgPath
        self.layer.addSublayer(gradientLayer)
        
        let curveLayer = CAShapeLayer()
        curveLayer.path = curvePath.cgPath
        curveLayer.lineWidth = 2.0
        curveLayer.strokeColor = RANDOM_COLOR().cgColor
        curveLayer.fillColor = UIColor.clear.cgColor
        self.curveLayer = curveLayer
        self.layer.addSublayer(curveLayer)
        
        let maskLayer = CAGradientLayer()
        maskLayer.frame = self.bounds
        maskLayer.colors = [
            RANDOM_COLOR().cgColor,
            RANDOM_COLOR().cgColor,
            RANDOM_COLOR().cgColor,
            RANDOM_COLOR().cgColor
        ]
        maskLayer.locations = [0, 0.3, 0.5, 1]
        maskLayer.startPoint = CGPoint(x: 0, y: 0)
        maskLayer.endPoint = CGPoint(x: 0.8, y: 1)
        maskLayer.mask = gradientLayer
        self.gradientPath = gradientPath
        self.gradientLayer = maskLayer
        self.layer.addSublayer(maskLayer)
    }
    
    // MARK: 动画
    func startCurveAnimation() {
        self.curveLayer?.isHidden = false
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.8
        self.curveLayer?.add(animation, forKey: nil)
        self.perform(#selector(gradientAnimation), with: nil, afterDelay: 0)
    }
    
    @objc func gradientAnimation() {
        self.gradientLayer?.isHidden = false
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.8
        self.gradientLayer?.add(animation, forKey: nil)
    }
    
}

