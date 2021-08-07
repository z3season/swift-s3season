//
//  PieModel.swift
//  SwiftS3season
//
//  Created by season on 2021/8/5.
//

import UIKit

// 象限
enum QuadrantType {
    case first
    case two
    case three
    case four
}

let pie_duration = 1.2

class PieModel {

    var desc: String = ""
    var angle: CGFloat {
        willSet {
            
        }
        didSet {
            self.duration = (self.angle / (CGFloat.pi * 2))
        }
    }
    var endAngle: CGFloat = 0
    var startAngle: CGFloat = 0
    var totalValue: CGFloat = 0
    var alpha: CGFloat = 1.0
    var isMoveOut: Bool = false
    var duration: CGFloat = 0.5
    
    var angleNum: CGFloat {
        get {
            return RADIANS_TO_DEGREES(self.endAngle - self.startAngle)
        }
    }
    
    init(angle: CGFloat, alpha: CGFloat, desc: String) {
        self.angle = angle
        self.alpha = alpha
        self.desc = desc
    }
    
    func caculateAngle(_ startAngle: CGFloat, _ maxValue: CGFloat) {
        self.endAngle = startAngle + self.angle
    }
    
    func transform() -> CATransform3D {
        var transform3D = CATransform3DIdentity
        if !isMoveOut {
            return transform3D
        }
        transform3D.m34 = -1.0 / 500.0
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        let moveLine: CGFloat = 20.0
        
        // 从 -π/2位置开始
        let startAngle = self.startAngle + CGFloat.pi * 0.5
        let endAngle = self.endAngle + CGFloat.pi * 0.5
        
        // 中分线的角度
        let centerAngle = ((startAngle + endAngle) * 0.5)
        var resultAngle: CGFloat = 0
        if (centerAngle > 0 && centerAngle <= CGFloat.pi * 0.5) {
            // 第一象限
            resultAngle = (CGFloat.pi - endAngle - startAngle) * 0.5
            x = cos(resultAngle) * moveLine
            y = -sin(resultAngle) * moveLine
        } else if (centerAngle > CGFloat.pi * 0.5 && centerAngle <= CGFloat.pi) {
            // 第二象限
            resultAngle = (endAngle + startAngle - CGFloat.pi) * 0.5
            x = cos(resultAngle) * moveLine
            y = sin(resultAngle) * moveLine
        } else if (centerAngle > CGFloat.pi && centerAngle <= CGFloat.pi * 1.5) {
            // 第三象限
            resultAngle = (3 * CGFloat.pi - endAngle - startAngle) * 0.5
            x = -cos(resultAngle) * moveLine
            y = sin(resultAngle) * moveLine
        } else {
            // 第四象限
            resultAngle = (endAngle + startAngle - CGFloat.pi * 3) * 0.5
            x = -cos(resultAngle) * moveLine
            y = -sin(resultAngle) * moveLine
        }
                
        transform3D = CATransform3DTranslate(transform3D, x, y, 0)
        return transform3D
    }
    
}
