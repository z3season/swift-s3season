//
//  CAChartVC.swift
//  SwiftS3season
//
//  Created by mula on 2021/8/5.
//

import UIKit

class CAChartVC: BaseViewController {

    let graphView: GraphView = {
        let v = GraphView(frame: CGRect(x: 16, y: 10, width: SCREEN_WIDTH - 32, height: 200))
        return v;
    }()
    let pieChartView: PieChartView = {
        let v = PieChartView(frame: CGRect(x: 16, y: 250, width: SCREEN_WIDTH - 32, height: 300))
        return v;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.graphView)
        self.view.addSubview(self.pieChartView)
    }

}
