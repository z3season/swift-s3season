//
//  AppDelegate.swift
//  SwiftS3season
//
//  Created by mula on 2021/7/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        window?.backgroundColor = .white
        window?.rootViewController = SZ_MainTabBarControllerViewController()
        window?.makeKeyAndVisible()
        // 可以加速所有的视图动画来进行自动化测试（注意对于在主窗口之外的视图并不会被影响，比如UIAlertview）
//        window?.layer.speed = 100;

        return true
    }

}

