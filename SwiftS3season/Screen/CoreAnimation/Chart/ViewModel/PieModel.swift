//
//  PieModel.swift
//  SwiftS3season
//
//  Created by mula on 2021/8/5.
//

import UIKit

class PieModel: NSObject {

    var desc: String = ""
    var angle: CGFloat = 0.0
    var endAngle: CGFloat = 0
    var startAngle: CGFloat = 0
    var totalValue: CGFloat = 0
    var alpha: CGFloat = 1.0
    
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
    
}
