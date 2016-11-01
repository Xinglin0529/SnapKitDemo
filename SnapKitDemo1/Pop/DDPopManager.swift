//
//  DDPopManager.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/10/31.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class DDPopManager: NSObject {
    
    class func initConfig() {
        DDPopWindow.shared.cacheWindow()
    }
    
    class func touchWildHide(hide: Bool) {
        DDPopWindow.shared.touchWildToHide = hide
    }
    
    class func hideAllPopView() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopViewHideNotification), object: nil, userInfo: nil)
    }
    
    @discardableResult
    class func showCenterAlert(withCustomView customView: UIView) -> DDBasePopView {
        DDPopManager.initConfig()
        DDPopManager.touchWildHide(hide: true)
        let base: DDBasePopView = DDBasePopView()
        base.frame = customView.frame
        base.addSubview(customView)
        
        customView.snp.makeConstraints { (make) in
            make.edges.equalTo(base)
            make.size.equalTo(customView.frame.size)
        }
        base.type = .Alert
        base.show()
        return base
    }
}
