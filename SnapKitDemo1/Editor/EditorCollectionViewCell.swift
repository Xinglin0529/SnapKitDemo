//
//  EditorCollectionViewCell.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/13.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class EditorCollectionViewCell: UICollectionViewCell {
    
    var text: String = "" {
        willSet {
            textLabel.text = newValue
        }
    }
    
    fileprivate let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .red
        self.contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
