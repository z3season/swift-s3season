//
//  HomeViewController.swift
//  SwiftS3season
//
//  Created by season on 2021/7/22.
//

import UIKit
import SnapKit
import NVActivityIndicatorView
import MJRefresh
import SwiftyJSON
import QuartzCore
import JXPagingView

// MARK: kvo监听
class KVOClass: NSObject {
   @objc dynamic var currentValue: String = "我可以被监听"
   var otherValue: String = "我不能被监听"
}

/*
 
 一般问释放池的实现，和内部的api使用，如果让你去设计一套，你有什么思路

 所以会了原理，你就把系统实现的那一套原理说一遍，就说是你自己的 面试官考察的就是你是否知道原理

 比如设计通知，设计kvo，都是这样的目的



 二面可能问优化性能的

 内存优化，卡顿优化，oom、包大小 启动优化

 三面问算法
 */

class HomeVC: BasePageVC {

    lazy var naviBGView: UIView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNeedHeader = true

        self.view.backgroundColor = UIColor.white

        let topSafeMargin = getKeyWindow().jx_layoutInsets().top
        let naviHeight = getKeyWindow().jx_navigationHeight()
        //导航栏隐藏就是设置pinSectionHeaderVerticalOffset属性即可，数值越大越往下沉
        pagingView.pinSectionHeaderVerticalOffset = Int(naviHeight)

        //自定义导航栏
        naviBGView.alpha = 0
        naviBGView.backgroundColor = UIColor.white
        naviBGView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: naviHeight)
        self.view.addSubview(naviBGView)

        let naviTitleLabel = UILabel()
        naviTitleLabel.textColor = UIColor(hex: "#111111")
        naviTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        naviTitleLabel.text = "首页"
        naviTitleLabel.textAlignment = .center
        naviTitleLabel.frame = CGRect(x: 0, y: topSafeMargin, width: self.view.bounds.size.width, height: 44)
        naviBGView.addSubview(naviTitleLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func preferredPagingView() -> JXPagingView {
        return JXPagingListRefreshView(delegate: self)
    }

    @objc func naviBack(){
        self.navigationController?.popViewController(animated: true)
    }

    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
        let thresholdDistance: CGFloat = 100
        var percent = scrollView.contentOffset.y/thresholdDistance
        percent = max(0, min(1, percent))
        naviBGView.alpha = percent
    }

}

class HomeSubVc: UIViewController {
    
    var text: KVOClass = KVOClass()
    fileprivate lazy var dataArray: [HomeModel] = []
    var listViewDidScrollCallback: ((UIScrollView) -> ())?

    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.mj_header = MJRefreshNormalHeader()
        v.mj_header?.setRefreshingTarget(self, refreshingAction: #selector(refreshData))
        v.backgroundColor = UIColor(hex: "#f3f3f3")
        v.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
        v.separatorStyle = .none
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#f3f3f3")
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        text.addObserver(self, forKeyPath: "currentValue", options: .new, context: nil)
        text.addObserver(self, forKeyPath: "otherValue", options: .new, context: nil)
        text.currentValue = "码农1"
        text.otherValue = "码农2"
        loadData()
    }
        
    deinit {
        text.removeObserver(self, forKeyPath: "currentValue")
        text.removeObserver(self, forKeyPath: "otherValue")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("\(keyPath!) change to \(change![.newKey] as! String)")
    }

    func loadData() {
        let path = Bundle.main.path(forResource: "home_data", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let dic = jsonData as! NSDictionary;
            let array = dic["data"] as! [Any]
            for item in array {
                let json = JSON.init(item)
                let model = HomeModel(jsonData: json);
                dataArray.append(model)
            }
            self.tableView.reloadData()
        } catch {}
    }
    
    @objc func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.mj_header?.endRefreshing()
        }
    }
        
}

extension HomeSubVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HomeTableViewCell
        tableViewCell.homeModel = self.dataArray[indexPath.row]
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArray[indexPath.row]
    
        // swift获取类 必须拼接包名
        let workName = Bundle.main.infoDictionary?["CFBundleExecutable"] as! String
        let className: String = model.routerKey ?? "BaseViewController"
        
        guard let vcClass = NSClassFromString("\(workName).\(className)") else {
          return
        }
        guard let customClass = vcClass as? BaseViewController.Type else {
          return
        }
        let vc = customClass.init()
        self.navigationController?.pushViewController(vc , animated: true);
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
    
}

extension HomeSubVc: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return view
    }

    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }

    func listScrollView() -> UIScrollView {
        return self.tableView
    }

    func listWillAppear() {
//        print("\(self.title ?? ""):\(#function)")
    }

    func listDidAppear() {
//        print("\(self.title ?? ""):\(#function)")
    }

    func listWillDisappear() {
//        print("\(self.title ?? ""):\(#function)")
    }

    func listDidDisappear() {
//        print("\(self.title ?? ""):\(#function)")
    }
}
