//
//  SZ_MainTabBarControllerViewController.swift
//  SwiftS3season
//
//  Created by season on 2021/7/21.
//

import UIKit

class SZ_MainTabBarControllerViewController: UITabBarController, UITabBarControllerDelegate {
    
    let textSize: CGFloat = 10;
    let tabBarNormalImages = ["icon_tab_home","icon_tab_feilei", "icon_tab_push", "icon_tab_msg","icon_tab_mine"]
    let tabBarSelectedImages = ["icon_tab_home_sel","icon_tab_feilei_sel", "icon_tab_push", "icon_tab_msg_sel","icon_tab_mine_sel"]
    let tabBarTitles = ["首页","分类", "","消息","我的"]

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        //设置系统默认的蓝色
        self.tabBar.tintColor = UIColor(red: 0/255, green:169/255, blue:169/255, alpha:1)
        self.tabBar.barTintColor = .white;
        createTabbarSecond();
        UINavigationBar.appearance().tintColor = .white

//        guard self.hiddenTabbarLine else {
//            return;
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        UITabBar.appearance().isTranslucent = false;
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        UITabBar.appearance().isTranslucent = false;
    }
    
    func createTabbarSecond(){
        var vc : UIViewController?
        for i in 0..<self.tabBarNormalImages.count {
            //创建根控制器
            switch i {
            case 0:
                vc = HomeVC()
            case 1:
                vc = ViewController()
            case 2:
                vc = ViewController()
            case 3:
                vc = ViewController()
            case 4:
                vc = ViewController()
            default:
                break
            }
            //创建导航控制器
            let nav = SZ_MainNavigationControll.init(rootViewController: vc!)
                            
            //1.创建tabbarItem
            let barItem = UITabBarItem.init(title: self.tabBarTitles[i], image: UIImage.init(named: self.tabBarNormalImages[i])?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.init(named: self.tabBarSelectedImages[i])?.withRenderingMode(.alwaysOriginal))
            
            //2.更改字体颜色大小
            barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], for: .normal)
            barItem.setTitleTextAttributes([NSAttributedString.Key.font :UIFont.systemFont(ofSize: 13)], for: .normal)
            barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], for: .selected)
            //设置标题
            vc?.title = self.tabBarTitles[i]
            vc?.tabBarItem = barItem
            setupTabbarItemTextStyle(vc: vc ?? UIViewController())

            if i == 2 {
                let offset:CGFloat;
                offset = 22;
                nav.tabBarItem.imageInsets = UIEdgeInsets(top: -offset, left: 0, bottom: offset, right: 0);
            }
            
            self.addChild(nav)
        }
    }
    
    // 隐藏tabbar上部的分隔线
    lazy var hiddenTabbarLine: Bool = {
        for view in self.tabBar.subviews {
        if view.frame.width == UIScreen.main.bounds.size.width {
               for image in view.subviews {
                    if image.frame.height < 2 {
                        image.isHidden = true;
                        return true;
                    }
               }
           }
        }
        return true;
    }()
    
    // 设置tabbarItem文字颜色、字体
    func setupTabbarItemTextStyle(vc: UIViewController) {
        if #available(iOS 13, *) {
            //UITabBar.appearance().unselectedItemTintColor = HEXCOLOR(c: 0x00ff00); // 这种方式无效
            //UITabBar.appearance().tintColor = HEXCOLOR(c: 0xff0000);
            let appearance = UITabBarAppearance();
            // 设置未被选中的颜色、字体
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: textSize)];
            // 设置被选中时的颜色、字体
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: textSize)];
            vc.tabBarItem.standardAppearance = appearance;
        } else {
            // 设置未被选中的颜色、字体
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: textSize)], for: .normal);
            // 设置被选中时的颜色、字体
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: textSize)], for: .selected);
            // 设置字体偏移
//             UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0.0,vertical: 0.0);
        }
    }
    
    // MARK: UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if (viewController.title == "") {
            let publish = ViewController();
            publish.title = "发布";
            let nav = SZ_MainNavigationControll(rootViewController: publish);
            nav.hidesBottomBarWhenPushed = true;
            nav.modalTransitionStyle = .coverVertical;
            nav.modalPresentationStyle = .fullScreen;
            present(nav, animated: true, completion: nil);
            return false;
        }
        return true;
    }

}
