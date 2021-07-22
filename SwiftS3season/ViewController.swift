//
//  ViewController.swift
//  SwiftS3season
//
//  Created by mula on 2021/7/21.
//

import UIKit

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .gray
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
    }

    // 修改状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .darkContent
    }
    
}

