//
//  DDPopManager.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/10/31.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class DDPopManager: NSObject {
    
    public class func initConfig() {
        DDPopWindow.shared.cacheWindow()
    }
    
    public class func touchWildHide(hide: Bool) {
        DDPopWindow.shared.touchWildToHide = hide
    }
    
    public class func hideAllPopView() {
        NotificationCenter.default.post(name: NSNotification.Name.PopViewAction.hide, object: nil, userInfo: nil)
    }
    
    @discardableResult
    public class func showCenterAlert(withCustomView customView: UIView) -> DDBasePopView {
        return createPopView(type: .Alert, customView: customView)
    }
    
    @discardableResult
    public class func showActionSheet(withCustomView customView: UIView) -> DDBasePopView {
        return createPopView(type: .Sheet, customView: customView)
    }
    
    private class func createPopView(type: DDPopupType, customView: UIView) -> DDBasePopView {
        DDPopManager.initConfig()
        DDPopManager.touchWildHide(hide: true)
        let base: DDBasePopView = DDBasePopView()
        base.bounds = customView.bounds
        base.addSubview(customView)
        
        customView.snp.makeConstraints { (make) in
            make.edges.equalTo(base)
            make.size.equalTo(customView.frame.size)
        }
        base.type = type
        base.show()
        return base
    }
}
