//
//  CubeVC.swift
//  SwiftS3season
//
//  Created by mula on 2021/8/2.
//

import UIKit
import GLKit

// 绘制一个正方体 CATransform3DMakeTranslation CATransform3DRotate

// CATransformLayer

class CubeVC: BaseViewController {

    var face1: UIView = UIView.init()
    var face2: UIView = UIView.init()
    var face3: UIView = UIView.init()
    var face4: UIView = UIView.init()
    var face5: UIView = UIView.init()
    var face6: UIView = UIView.init()
    let boxWidth: CGFloat = 200.0

    override func viewDidLoad() {
        super.viewDidLoad()
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 500.0;
        // x轴选择45°
        perspective = CATransform3DRotate(perspective, -(CGFloat.pi / 4), 1, 0, 0);
        perspective = CATransform3DRotate(perspective, -(CGFloat.pi / 4), 0, 1, 0);
        self.view.layer.sublayerTransform = perspective;

        var transform = CATransform3DMakeTranslation(0, 0, boxWidth / 2);
        self.addFace(view: face1, transform: transform, index: 0)
        face1.backgroundColor = UIColor(white: 0.8, alpha: 0.7)
        transform = CATransform3DMakeTranslation(boxWidth / 2, 0, 0);
        transform = CATransform3DRotate(transform, CGFloat.pi / 2, 0, 1, 0);
        self.addFace(view: face2, transform: transform, index: 1)
        transform = CATransform3DMakeTranslation(0, -(boxWidth / 2), 0);
        transform = CATransform3DRotate(transform, CGFloat.pi / 2, 1, 0, 0);
        self.addFace(view: face3, transform: transform, index: 2)
        transform = CATransform3DMakeTranslation(0, boxWidth / 2, 0);
        transform = CATransform3DRotate(transform, -(CGFloat.pi / 2), 1, 0, 0);
        self.addFace(view: face4, transform: transform, index: 3)
        transform = CATransform3DMakeTranslation(-(boxWidth / 2), 0, 0);
        transform = CATransform3DRotate(transform, -(CGFloat.pi / 2), 0, 1, 0);
        self.addFace(view: face5, transform: transform, index: 4)
        transform = CATransform3DMakeTranslation(0, 0, -(boxWidth / 2));
        transform = CATransform3DRotate(transform, CGFloat.pi, 0, 1, 0);
        self.addFace(view: face6, transform: transform, index: 5)
    }
    
    func addFace(view: UIView, transform: CATransform3D, index: Int) {
        self.view .addSubview(view)
        let containerSize = self.view.bounds.size
        view.frame = CGRect(x: 0, y: 0, width: boxWidth, height: boxWidth)
        view.backgroundColor = RANDOM_COLOR()
        let text = UILabel.init(frame: CGRect(x: 0, y: 0, width: boxWidth, height: boxWidth))
        text.text = "\(index + 1)"
        text.font = UIFont.boldSystemFont(ofSize: 60)
        text.textAlignment = .center
        view.addSubview(text)
        view.center = CGPoint(x: (containerSize.width / 2.0), y: (containerSize.height / 2.0))
        view.layer.transform = transform
    }
    
}
