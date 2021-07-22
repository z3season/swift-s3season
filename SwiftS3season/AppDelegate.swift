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
        
        return true
    }

}

