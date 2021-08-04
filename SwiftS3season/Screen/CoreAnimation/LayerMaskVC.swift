//
//  LayerMaskVC.swift
//  SwiftS3season
//
//  Created by mula on 2021/8/4.
//

import UIKit

/*
 CALayer有一个属性叫做mask可以解决这个问题。这个属性本身就是个CALayer类型，有和其他图层一样的绘制和布局属性。
 它类似于一个子图层，相对于父图层（即拥有该属性的图层）布局，但是它却不是一个普通的子图层。
 不同于那些绘制在父图层中的子图层，mask图层定义了父图层的部分可见区域。

 mask图层的Color属性是无关紧要的，真正重要的是图层的轮廓。mask属性就像是一个饼干切割机，mask图层实心的部分会被保留下来，其他的则会被抛弃。

 如果mask图层比父图层要小，只有在mask图层里面的内容才是它关心的，除此以外的一切都会被隐藏起来。
 */

class LayerMaskVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            
        let imgV = UIImageView(image: UIImage(named: "img_01.jpeg"))
        imgV.frame = CGRect(x: 50, y: 100, width: 200, height: 300)
        
        let maskLayer = CALayer()
        maskLayer.frame = imgV.bounds
        maskLayer.contents = UIImage(named: "car")?.cgImage
        imgV.layer.mask = maskLayer
        self.view.addSubview(imgV)
        
    }
    
}
