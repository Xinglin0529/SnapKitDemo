//
//  ScaleAvatar.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/8.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class ScaleAvatar: UIView {
    
    fileprivate let avatar: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage.init(named: "safe_loan_prediction_header_bgimage")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(avatar)
        avatar.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
