//
//  PresentationController.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/21.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    
    var dimmingView: UIView?
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.dimmingView = UIView()
        self.dimmingView?.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        self.dimmingView?.alpha = 0
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect.zero
        let containerBounds = self.containerView?.bounds
        presentedViewFrame.size = CGSize(width: containerBounds!.size.width / 2, height: containerBounds!.size.height)
        presentedViewFrame.origin.x = containerBounds!.size.width - presentedViewFrame.size.width
        return presentedViewFrame
    }
    
    override func presentationTransitionWillBegin() {
        self.dimmingView?.frame = containerView!.bounds
        self.dimmingView?.alpha = 0
        containerView?.insertSubview(self.dimmingView!, at: 0)
        
        if presentedViewController.transitionCoordinator != nil {
            presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (coordinateContext) in
                self?.dimmingView?.alpha = 1
            }, completion: nil)
        } else {
            self.dimmingView?.alpha = 1
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            self.dimmingView?.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinate = presentedViewController.transitionCoordinator else {
            return
        }
        coordinate.animate(alongsideTransition: { [weak self] (coordinateContext) in
            self?.dimmingView?.alpha = 0
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.dimmingView?.removeFromSuperview()
        }
    }
    
}
