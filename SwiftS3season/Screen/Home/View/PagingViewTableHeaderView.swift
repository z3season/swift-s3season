//
//  PagingViewTableHeaderView.swift
//  SwiftS3season
//
//  Created by mula on 2021/8/6.
//

import UIKit

class PagingViewTableHeaderView: UIView {
    lazy var imageView: UIImageView = UIImageView()
    var imageViewFrame: CGRect = CGRect.zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(imageView)
        imageView.kf.setImage(with: URL(string: "http://img.netbian.com/file/2021/0310/e6a30e5d21e7f08755be9b4f4caf1f6d.jpg"))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageViewFrame = bounds
    }

    func scrollViewDidScroll(contentOffsetY: CGFloat) {
        var frame = imageViewFrame
        frame.size.height -= contentOffsetY
        frame.origin.y = contentOffsetY
        imageView.frame = frame
    }

}
