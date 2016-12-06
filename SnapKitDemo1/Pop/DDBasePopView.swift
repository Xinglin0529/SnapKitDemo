//
//  DDBasePopView.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/10/31.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

extension Notification.Name {
    public struct PopViewAction {
        static let hide = Notification.Name(rawValue: "PopViewHideNotification")
    }
}

public enum DDPopupType {
    case Alert
    case Sheet
    case Custom
}

public typealias DDPopupClosure = (DDBasePopView) -> ()

open class DDBasePopView: UIView {
    
    fileprivate var visible: Bool {
        if self.attachedView != nil {
            return !self.attachedView!.dd_dimBackgroundView.isHidden
        }
        return false
    }
    
    fileprivate var isAllHide: Bool = false
    
    fileprivate var attachedView: UIView?
    
    public var type: DDPopupType {
        willSet {
            switch newValue {
            case .Alert:
                self.showAnimation = alertShowAnimation()
                self.hideAnimation = alertHideAnimation()
            case .Sheet:
                self.showAnimation = sheetShowAnimation()
                self.hideAnimation = sheetHideAnimation()
            case .Custom:
                self.showAnimation = customShowAnimation()
                self.hideAnimation = customHideAnimation()
            }
        }
    }
    
    public var animationDuration: TimeInterval {
        willSet {
            self.attachedView?.dd_dimAnimationDuration = newValue
        }
    }
    
    fileprivate var withKeyboard: Bool = false
    
    fileprivate var showCompletionBlock: DDPopupClosure?
    fileprivate var hideCompletionBlock: DDPopupClosure?
    fileprivate var showAnimation: DDPopupClosure?
    fileprivate var hideAnimation: DDPopupClosure?
    
    override init(frame: CGRect) {
        self.animationDuration = 0.3
        self.type = .Alert
        
        super.init(frame: frame)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DDBasePopView.tapAction(tap:)))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func hideKeyboard() {
        for window in UIApplication.shared.windows {
            for v in window.subviews {
                self.dismissAllKeyboardInView(view: v)
            }
        }
    }
    
    public func show() {
        show(with: nil)
    }
    
    public func show(with block: DDPopupClosure?) {
        NotificationCenter.default.addObserver(self, selector: #selector(DDBasePopView.hideImmediately(sender:)), name: NSNotification.Name.PopViewAction.hide, object: nil)
        if block != nil {
            self.showCompletionBlock = block
        }
        
        if self.attachedView == nil {
            self.attachedView = DDPopWindow.shared as UIView
        }
        self.attachedView?.dd_showDimBackground()
        
        self.showAnimation!(self)
        
        if self.withKeyboard {
            showKeyboard()
        }
    }
    
    public func cancel() {
        self.isAllHide = true
        hide()
    }
    
    public func hide() {
        hide(with: nil)
    }
    
    public func hide(with block: DDPopupClosure?) {
        if !self.visible {
            return
        }
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.PopViewAction.hide, object: nil)
        
        if block != nil {
            self.hideCompletionBlock = block
        }
        
        if self.attachedView == nil {
            self.attachedView = DDPopWindow.shared as UIView
        }
        
        self.attachedView?.dd_hideDimBackground(animated: self.isAllHide)
        self.isAllHide = false
        
        if self.withKeyboard {
            hideKeyboard()
        }
        self.hideAnimation!(self)
    }
    
    @objc private func hideImmediately(sender: Notification) {
        self.isAllHide = true
        hide(with: nil)
    }
    
    ///Animation Block
    
    private func alertShowAnimation() -> DDPopupClosure {
        let popClosure: DDPopupClosure = { [unowned self] (popView) in
            self.attachedView?.dd_dimBackgroundView.addSubview(self)
            self.snp.updateConstraints({ (make) in
                make.center.equalTo(self.attachedView!)
            })
            self.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.attachedView?.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: { [unowned self] in
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }, completion: { (finished) in
                UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 5.0, options: .allowUserInteraction, animations: { 
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }, completion: nil)
            })
        }
        return popClosure
    }
    
    private func alertHideAnimation() -> DDPopupClosure {
        let hideBlock: DDPopupClosure = { [unowned self] (popView) in
            self.attachedView?.layoutIfNeeded()
            UIView.animate(withDuration: 0.25, delay: 0, options: .allowAnimatedContent, animations: { 
                self.transform = CGAffineTransform(scaleX: 0, y: 0)
                self.attachedView?.layoutIfNeeded()
                }, completion: { (finished) in
                    if self.hideCompletionBlock != nil {
                        self.hideCompletionBlock!(self)
                    }
                    self.removeFromSuperview()
            })
        }
        return hideBlock
    }
    
    private func customShowAnimation() -> DDPopupClosure {
        return commonShowAnimation()
    }
    
    private func customHideAnimation() -> DDPopupClosure {
        return commonHideAnimation()
    }
    
    private func sheetShowAnimation() -> DDPopupClosure {
        return commonShowAnimation()
    }
    
    private func sheetHideAnimation() -> DDPopupClosure {
        return commonHideAnimation()
    }
    
    private func commonShowAnimation() -> DDPopupClosure {
        let showBlock: DDPopupClosure = { [unowned self] (popView) in
            self.attachedView?.dd_dimBackgroundView.addSubview(self)
            self.attachedView?.layoutIfNeeded()
            
            self.snp.updateConstraints({ (make) in
                make.centerX.equalTo(self.attachedView!)
                make.bottom.equalTo(self.attachedView!.snp.bottom).offset(self.frame.size.height)
            })
            
            self.attachedView?.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: { 
                if !self.withKeyboard {
                    self.snp.updateConstraints({ (make) in
                        make.centerX.equalTo(self.attachedView!)
                        make.bottom.equalTo(self.attachedView!).offset(5)
                    })
                } else {
                    UIView.setAnimationCurve(.linear)
                    self.snp.updateConstraints({ (make) in
                        make.centerX.equalTo(self.attachedView!)
                        make.bottom.equalTo(self.attachedView!).offset(-self.keyboardHeight())
                    })
                }
                self.attachedView?.layoutIfNeeded()
                }, completion: { (finished) in
                    if !self.withKeyboard {
                        self.attachedView?.layoutIfNeeded()
                        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 5, options: .allowUserInteraction, animations: { 
                                self.snp.updateConstraints({ (make) in
                                    make.centerX.equalTo(self.attachedView!)
                                    make.bottom.equalTo(self.attachedView!)
                                })
                            self.attachedView?.layoutIfNeeded()
                            }, completion: { (finished) in
                                
                        })
                    }
                    if self.showCompletionBlock != nil {
                        self.showCompletionBlock!(self)
                    }
                    self.showCompletionHandler()
            })
        }
        return showBlock
    }
    
    private func commonHideAnimation() -> DDPopupClosure {
        let hideBlock: DDPopupClosure = { [unowned self] (popView) in
            self.attachedView?.layoutIfNeeded()
            UIView.animate(withDuration: 0.25, delay: 0, options: .allowAnimatedContent, animations: { 
                    self.snp.updateConstraints({ (make) in
                        make.centerX.equalTo(self.attachedView!)
                        make.bottom.equalTo(self.attachedView!.snp.bottom).offset(self.frame.size.height)
                    })
                    self.attachedView?.layoutIfNeeded()
                }, completion: { (finished) in
                    if self.hideCompletionBlock != nil {
                        self.hideCompletionBlock!(self)
                    }
                    self.removeFromSuperview()
            })
        }
        return hideBlock
    }
    
    private func keyboardHeight() -> CGFloat {
        return 216.0
    }
    
    ///Override by subClass
    open func tapAction(tap: UITapGestureRecognizer) {
        
    }
    
    ///Override by subClass
    open func showKeyboard() {
        
    }

    ///Override by subClass
    open func showCompletionHandler() {
        
    }
    
    @discardableResult
    func dismissAllKeyboardInView(view: UIView) -> Bool {
        if view.isFirstResponder {
            view.resignFirstResponder()
        }
        for v in view.subviews {
            if self.dismissAllKeyboardInView(view: v) {
                return true
            }
        }
        return false
    }
}
