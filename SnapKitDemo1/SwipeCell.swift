//
//  SwipeCell.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/6.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class SwipeCell: SwipeBase {
    
    fileprivate let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override func update(withData data: SwipeItem) {
        super.update(withData: data)
        self.imageView.image = UIImage(named: data.placeHolder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
