//
//  Extensions.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/9.
//  Copyright © 2016年 com. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    class func ld_image(withColor color: UIColor) -> UIImage {
        return ld_image(withColor: color, size: CGSize(width: 1, height: 1))
    }
    
    class func ld_image(withColor color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIColor {
    class func ld_color(withHex hex: UInt) -> UIColor {
        return UIColor(red: CGFloat((hex & 0xff000000) >> 24) / 255.0,
                       green: CGFloat((hex & 0x00ff0000) >> 16) / 255.0,
                       blue: CGFloat((hex & 0x0000ff00) >> 8) / 255.0,
                       alpha: CGFloat(hex & 0x000000ff) / 255.0)
    }
}

fileprivate var backgroundKey = "backgroundKey"

extension UINavigationBar {
    private var overlay: UIView? {
        set {
            objc_setAssociatedObject(self, &backgroundKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &backgroundKey) as? UIView
        }
    }
    
    func setOverlayAlpha(alpha: CGFloat) {
        if self.overlay == nil {
            self.setBackgroundImage(UIImage(), for: .default)
            self.shadowImage = UIImage()
            self.overlay = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64))
            self.subviews.first?.insertSubview(self.overlay!, at: 0)
            self.overlay?.backgroundColor = UIColor.ld_color(withHex: 0x28b6ea).withAlphaComponent(1)
            self.overlay?.alpha = alpha
        } else {
            self.overlay?.alpha = alpha
        }
    }
    
    func setBackgroundColor(color: UIColor) {
        if self.overlay == nil {
            self.setBackgroundImage(UIImage(), for: .default)
            self.shadowImage = UIImage()
            self.overlay = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64))
            self.subviews.first?.insertSubview(self.overlay!, at: 0)
            self.overlay?.backgroundColor = color
        } else {
            self.overlay?.backgroundColor = color
        }
    }
}













