//
//  SZ_MainNavigationControll.swift
//  SwiftS3season
//
//  Created by mula on 2021/7/22.
//

import UIKit

class SZ_MainNavigationControll: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        navigationBar.barTintColor = .white
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .black
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        // 1.取出手势&view
        guard let gesture = interactivePopGestureRecognizer else { return }
        gesture.isEnabled = false
        let gestureView = gesture.view
        // 2.获取所有的target
        let target = (gesture.value(forKey: "_targets") as? [NSObject])?.first
        guard let transition = target?.value(forKey: "_target") else { return }
        let action = Selector(("handleNavigationTransition:"))
        // 3.创建新的手势
        let popGes = UIPanGestureRecognizer()
        popGes.maximumNumberOfTouches = 1
        gestureView?.addGestureRecognizer(popGes)
        popGes.addTarget(transition, action: action)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let vc = self.topViewController
        return vc!.preferredStatusBarStyle
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    // MARK: -- <UINavigationControllerDelegate>
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
    }

}
