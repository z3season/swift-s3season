//
//  BaseViewController.swift
//  SwiftS3season
//
//  Created by season on 2021/7/22.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.navigationController?.viewControllers.count ?? 0) > 0 {
            setNavBackBtn()
        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = .white
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    //在这里全局设置状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setNavBackBtn(){
        let imageName = "icon_nav_back"
        let item = UIBarButtonItem(image:  UIImage.init(named: imageName)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItems = [item]
    }

    @objc func back(){
        if (self.navigationController?.viewControllers[0] == self) {
            self.dismiss(animated: true, completion:nil)
            return;
        }
        self.navigationController?.popViewController(animated: true)
    }

}
