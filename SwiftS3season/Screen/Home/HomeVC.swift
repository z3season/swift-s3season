//
//  HomeViewController.swift
//  SwiftS3season
//
//  Created by mula on 2021/7/22.
//

import UIKit
import SnapKit
import NVActivityIndicatorView
import MJRefresh
import RxSwift
import RxCocoa

class HomeVC: BaseViewController {
    
    fileprivate lazy var dataArray = {
       ["1", "2", "3", "4"]
    }()
    
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
        
    }
        
    @objc func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.mj_header?.endRefreshing()
        }
    }
        
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return tableViewCell ?? UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(BaseErrorThrows(), animated: true);
    }
    
}
