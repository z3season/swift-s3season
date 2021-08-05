//
//  PieModel.swift
//  SwiftS3season
//
//  Created by mula on 2021/8/5.
//

import UIKit

// 象限
enum QuadrantType {
    case first
    case two
    case three
    case four
}

class PieModel: NSObject {

    var desc: String = ""
    var angle: CGFloat = 0.0
    var endAngle: CGFloat = 0
    var startAngle: CGFloat = 0
    var totalValue: CGFloat = 0
    var alpha: CGFloat = 1.0
    var isMoveOut: Bool = false
    
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
        transform3D.m34 = -1.0 / 500.0
        let x: CGFloat = 10.0
        let y: CGFloat = 10.0
        
        
        
        
        
        transform3D = CATransform3DTranslate(transform3D, x, y, 0)
        return transform3D
    }
    
}
