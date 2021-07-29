//
//  HomeViewModel.swift
//  SwiftS3season
//
//  Created by mula on 2021/7/28.
//

import UIKit
import SwiftyJSON

struct HomeModel {
    var title: String?
    var detail: String?
    var iconUrl: String?
    var routerKey: String?
    
    init(jsonData: JSON) {
        title = jsonData["title"].stringValue
        detail = jsonData["detail"].stringValue
        iconUrl = jsonData["icon_url"].stringValue
        routerKey = jsonData["router_key"].stringValue
    }
}
