//
//  HomeViewController.swift
//  SwiftS3season
//
//  Created by mula on 2021/7/22.
//

import UIKit

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true

        let btn:UIButton = UIButton.init(type: UIButton.ButtonType.custom);//新建btn
        btn.frame = CGRect.init(x: 10, y: 10, width: 100, height: 100);//frame位置和大小
        btn.backgroundColor = UIColor.red;//背景色
        btn.imageView?.image = UIImage.init(named: "icon_tab_mine_sel")//设置图片
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true //设置圆角
        btn.setTitle("点击", for:  UIControl.State.normal)//设置标题
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)//设置字体大小
        btn.addTarget(self, action: #selector(push), for: .touchUpInside)
        self.view.addSubview(btn);
    }
    
    @objc func push() {
        self.navigationController?.pushViewController(BaseClassStruct(), animated: true);
    }
    
}
