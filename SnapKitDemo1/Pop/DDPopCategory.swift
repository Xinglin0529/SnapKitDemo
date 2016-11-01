//
//  DDPopCategory.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/10/31.
//  Copyright © 2016年 com. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public class func dd_color(withHex hex: UInt) -> UIColor {
        return UIColor(red: CGFloat((hex & 0xff000000) >> 24) / 255.0,
                       green: CGFloat((hex & 0x00ff0000) >> 16) / 255.0,
                       blue: CGFloat((hex & 0x0000ff00) >> 8) / 255.0,
                       alpha: CGFloat(hex & 0x000000ff) / 255.0)
    }
}

extension UIImage {
    public class func dd_image(withColor color: UIColor) -> UIImage {
        return UIImage.dd_image(withColor: color, size: CGSize(width: 4, height: 4))
    }
    
    public class func dd_image(withColor color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!.dd_streched()
    }
    
    public func dd_streched() -> UIImage {
        let size = self.size
        let insets = UIEdgeInsets(top: (size.height - 1.0) / 2, left: (size.width - 1) / 2, bottom: (size.height - 1.0) / 2, right: (size.width - 1) / 2)
        return self.resizableImage(withCapInsets: insets)
    }
}

extension UIButton {
    public class func dd_button(addTarget target: Any?, action: Selector) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.addTarget(target, action: action, for: .touchUpInside)
        return btn
    }
}

extension NSString {
    public func dd_truncate(byCharLength charLength: UInt) -> NSString {
        var length = 0
        self.enumerateSubstrings(in: NSRange(location: 0, length: self.length), options: .byComposedCharacterSequences) { (subString, subStringRange, enclosingRange, stop) in
            if subStringRange.length + length > Int(charLength) {
                return
            }
            length += subStringRange.length
        }
        return self.substring(to: length) as NSString
    }
}

fileprivate var dd_dimReferenceCountKey = "dd_dimReferenceCountKey"
fileprivate var dd_dimBackgroundViewKey = "dd_dimBackgroundViewKey"
fileprivate var dd_dimAnimationDurationKey = "dd_dimAnimationDurationKey"
fileprivate var dd_dimBackgroundAnimatingKey = "dd_dimBackgroundAnimatingKey"

extension UIView {
    var dd_dimRefrenceCount: NSInteger? {
        set {
            objc_setAssociatedObject(self, &dd_dimReferenceCountKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            return objc_getAssociatedObject(self, &dd_dimReferenceCountKey) as? NSInteger
        }
    }
}

extension UIView {
    var dd_dimBackgroundView: UIView {
        var dd_dimView = objc_getAssociatedObject(self, &dd_dimBackgroundViewKey) as? UIView
        if dd_dimView == nil {
            dd_dimView = UIView()
            self.addSubview(dd_dimView!)
            dd_dimView?.snp.makeConstraints({ (make) in
                make.edges.equalTo(self)
            })
            dd_dimView?.isHidden = true
            self.dd_dimAnimationDuration = 0.3
            objc_setAssociatedObject(self, &dd_dimBackgroundViewKey, dd_dimView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return dd_dimView!
    }
    
    private(set) var dd_dimBackgroundAnimating: Bool {
        set {
            objc_setAssociatedObject(self, &dd_dimBackgroundAnimatingKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            return objc_getAssociatedObject(self, &dd_dimBackgroundAnimatingKey) as! Bool
        }
    }
    
    var dd_dimAnimationDuration: TimeInterval? {
        get {
//            return objc_getAssociatedObject(self, &dd_dimAnimationDurationKey) as? TimeInterval
            return 0.3
        }
        set {
            objc_setAssociatedObject(self, &dd_dimAnimationDurationKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public func dd_showDimBackground() {
        self.dd_dimRefrenceCount? += 1
        
        if let dimRefrenceCount = self.dd_dimRefrenceCount {
            if dimRefrenceCount > 1 {
                return
            }
        }
        
        self.dd_dimBackgroundView.isHidden = false
        self.dd_dimBackgroundAnimating = true
        if self is UIWindow {
            self.isHidden = false
            (self as! UIWindow).makeKeyAndVisible()
        } else {
            self.bringSubview(toFront: self.dd_dimBackgroundView)
        }
        
        UIView.animate(withDuration: self.dd_dimAnimationDuration!, delay: 0, options: [.curveLinear, .beginFromCurrentState], animations: {[unowned self] in
                self.dd_dimBackgroundView.backgroundColor = UIColor.dd_color(withHex: 0x0000007f)
            }) { [unowned self](finished) in
                if finished {
                    self.dd_dimBackgroundAnimating = false
                }
        }
    }
    
    public func dd_hideDimBackground(animated: Bool) {
        self.dd_dimRefrenceCount? -= 1
        if let dimRefrenceCount = self.dd_dimRefrenceCount {
            if dimRefrenceCount > 0 {
                return
            }
        }
        
        if animated {
            self.dd_dimBackgroundAnimating = true
            UIView.animate(withDuration: self.dd_dimAnimationDuration!, delay: 0, options: [.curveLinear, .beginFromCurrentState], animations: { [unowned self] in
                    self.dd_dimBackgroundView.backgroundColor = UIColor.dd_color(withHex: 0x00000000)
                }, completion: { [unowned self](finished) in
                    if finished {
                        self.dd_dimBackgroundView.isHidden = true
                        self.dd_dimBackgroundAnimating = false
                        
                        if self is UIWindow {
                            self.isHidden = true
                            UIApplication.shared.delegate?.window??.makeKey()
                        }
                    }
            })
        } else {
            self.dd_dimBackgroundView.backgroundColor = UIColor.dd_color(withHex: 0x00000000)
            self.dd_dimBackgroundView.isHidden = true
            self.dd_dimBackgroundAnimating = false
            
            if self is UIWindow {
                self.isHidden = true
                UIApplication.shared.delegate?.window??.makeKey()
            }
        }
    }
}
