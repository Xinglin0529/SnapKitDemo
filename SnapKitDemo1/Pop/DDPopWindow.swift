//
//  DDPopWindow.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/10/31.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class DDPopWindow: UIWindow {
    
    var touchWildToHide: Bool = false
    
    static let shared = DDPopWindow()
    
    private var keyboardRect: CGRect?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.windowLevel = UIWindowLevelStatusBar + 1
        NotificationCenter.default.addObserver(self, selector: #selector(DDPopWindow.keyboardFrameDidChanged(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DDPopWindow.tapAction(tap:)))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func keyboardFrameDidChanged(sender: Notification) {
        let keyboardBoundsValue: NSValue = sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        self.keyboardRect = keyboardBoundsValue.cgRectValue
    }
    
    func tapAction(tap: UITapGestureRecognizer) {
        if self.touchWildToHide && !self.dd_dimBackgroundAnimating {
            
            for v in self.dd_dimBackgroundView.subviews {
                if v is DDBasePopView {
                    (v as! DDBasePopView).cancel()
                }
            }
        }
    }
    
    func cacheWindow() {
        self.backgroundColor = .clear
        self.makeKeyAndVisible()
        UIApplication.shared.delegate?.window??.makeKey()
        self.isHidden = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
}
