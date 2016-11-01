//
//  CustomAlert.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/10/31.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class CustomAlert: DDBasePopView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        let text = UILabel()
        text.text = "测试测试时测试测试测试时测试测试测试时测试测试测试时测试测试测试时测试测试测试时测试测试测试时测试"
        text.font = UIFont.systemFont(ofSize: 16)
        text.textAlignment = .left
        text.textColor = .red
        text.numberOfLines = 0
        self.addSubview(text)
        
        text.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.top.equalTo(self).offset(20)
        }
        
        let button = UIButton(type: .custom)
        button.backgroundColor = .blue
        button.setTitle("关闭", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(CustomAlert.closeAlert), for: .touchUpInside)
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(20)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(44)
        }
    }
    
    func closeAlert() {
        DDPopManager.hideAllPopView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
