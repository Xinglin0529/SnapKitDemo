//
//  ActionSheet.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/12.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class ActionSheet: UIView {
    
    private var backgroundView: UIControl = UIControl()
    private var container: UIView = UIView()
    private var originCenter: CGPoint = .zero
    private var isUp: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(backgroundView)
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        backgroundView.addTarget(self, action: #selector(ActionSheet.hide), for: .touchUpInside)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.height.equalTo(300)
            make.bottom.equalTo(self.snp.bottom).offset(240)
        }

        let item = UIView()
        item.backgroundColor = .red
        container.addSubview(item)
        item.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(container)
            make.top.equalTo(container.snp.top).offset(60)
            make.bottom.equalTo(container.snp.bottom)
        }
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(ActionSheet.panGestureAction(pan:)))
        container.addGestureRecognizer(panGesture)
        container.addObserver(self, forKeyPath: "center", options: [.new, .old], context: nil)
    }
    
    @objc private func hide() {
        
    }
    
    @objc private func panGestureAction(pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            originCenter = container.center
        } else if pan.state == .changed {
            let size = container.frame.size
            let translate = pan.translation(in: container)
            let deltaY = translate.y
            let containerCenter = container.center
            var newCenterY = containerCenter.y + deltaY
            
            if newCenterY <= self.frame.size.height - (size.height - 60) / 2 {
                newCenterY = self.frame.size.height - (size.height - 60) / 2
            }
            
            if newCenterY >= self.frame.size.height + (size.height - 60) / 2 {
                newCenterY = self.frame.size.height + (size.height - 60) / 2
            }
            container.center = CGPoint(x: containerCenter.x, y: newCenterY)
            
            let alpha = 0.5 * (originCenter.y - newCenterY) / 240
            if alpha >= 0 {
                isUp = true
                if alpha == 0 {
                    backgroundView.alpha = 0.5
                    return
                }
                backgroundView.alpha = alpha
            } else {
                isUp = false
                let temp = 0.5 + alpha
                if temp == 0.5 {
                    backgroundView.alpha = 0
                    return
                }
                backgroundView.alpha = 0.5 + alpha
            }
            pan.setTranslation(CGPoint.zero, in: self)
        } else if pan.state == .cancelled || pan.state == .ended {
            var center = container.center
            let size = container.frame.size
            var isDown = false
            if center.y <= self.frame.size.height - (size.height - 60) / 2 + 150 {
                center.y = self.frame.size.height - (size.height - 60) / 2
                isDown = false
            }
            
            if center.y >= self.frame.size.height + (size.height - 60) / 2 - 150 {
                center.y = self.frame.size.height + (size.height - 60) / 2
                isDown = true
            }
            
            let interval: Double = Double(pan.velocity(in: self).x * 0.00002 + 0.2)
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(interval)
            UIView.setAnimationCurve(.easeOut)
            if isUp {
                if isDown == true {
                    backgroundView.alpha = 0
                } else {
                    backgroundView.alpha = 0.5
                }
            } else {
                if isDown == false {
                    backgroundView.alpha = 0.5
                } else {
                    backgroundView.alpha = 0
                }
            }
            container.center = center
            UIView.commitAnimations()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "center" {
            let c = object as! UIView
            let d = change![.newKey] as! CGPoint
            print("c is \(c), d is \(d)")
        }
    }
    
    deinit {
        container.removeObserver(self, forKeyPath: "center")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
