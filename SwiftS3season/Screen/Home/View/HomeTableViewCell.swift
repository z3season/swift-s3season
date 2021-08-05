//
//  HomeTableViewCell.swift
//  SwiftS3season
//
//  Created by mula on 2021/7/26.
//

import UIKit
import Kingfisher

class HomeTableViewCell: UITableViewCell {
    
    public var homeModel:  HomeModel? {
        didSet {
            self.titleLable.text = self.homeModel?.title
            self.detailLabel.text = self.homeModel?.detail
            imgView.kf.setImage(with: URL(string: self.homeModel?.iconUrl ?? ""))
        }
    }

    lazy var imgView: UIImageView = {
        let img = UIImageView.init()
        img.layer.cornerRadius = SCALE_WIDTH(4)
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var titleLable: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor(hex: "#111111")
        return label
    }()
    lazy var detailLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor(hex: "#999999")
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        contentView.addSubview(imgView)
        contentView.addSubview(titleLable)
        contentView.addSubview(detailLabel)

        let selectedView = UIView(frame:CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectedView

        
//        imgView.kf.setImage(with: URL(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fbpic.588ku.com%2Felement_origin_min_pic%2F16%2F10%2F29%2F2ac8e99273bc079e40a8dc079ca11b1f.jpg&refer=http%3A%2F%2Fbpic.588ku.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1629875308&t=e40f6a286630140cf46bd2beb2e60ffd"))
    
        imgView.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTH(16.0))
            make.centerY.equalToSuperview()
            make.width.height.equalTo(80)
        }
        titleLable.snp.makeConstraints { make in
            make.left.equalTo(imgView.snp.right).offset(10)
            make.top.equalTo(imgView.snp.top)
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-16)
        }
        detailLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLable)
            make.top.equalTo(self.titleLable.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
