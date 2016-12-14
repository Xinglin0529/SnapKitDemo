//
//  PuzzleView.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/13.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

public let ScreenWidth = UIScreen.main.bounds.size.width
public let ScreenHeight = UIScreen.main.bounds.size.height
fileprivate let ItemWidth = (ScreenWidth - 10) / 3

class PuzzleView: UIView {
    
    fileprivate var imageNames: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    fileprivate var imageComponents: [UIImageView] = []
    fileprivate var containerView: UIView!
    fileprivate var originCenter: CGPoint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    private func setupSubviews() {
        let containerView = UIView()
        containerView.layer.borderColor = UIColor.ld_color(withHex: 0xddbb89).cgColor
        containerView.layer.borderWidth = 5
        containerView.backgroundColor = UIColor.ld_color(withHex: 0x4c4c4c)
        self.containerView = containerView
        self.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.size.equalTo(CGSize(width: ScreenWidth, height: ScreenWidth))
        }
        
        for i in 0..<9 {
            let imageView = UIImageView()
            imageView.image = UIImage.init(named: "image\(imageNames[i])")
            imageView.isUserInteractionEnabled = true
            imageView.frame = CGRect(x: CGFloat(i % 3) * ItemWidth + 5, y: CGFloat(i / 3) * ItemWidth + 5, width: ItemWidth, height: ItemWidth)
            containerView.addSubview(imageView)
            let pan = UIPanGestureRecognizer.init(target: self, action: #selector(PuzzleView.panGestureAction(sender:)))
            imageView.addGestureRecognizer(pan)
            imageComponents.append(imageView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

// MARK: - UIPanGestureRecognize
extension PuzzleView {
    
    @objc fileprivate func panGestureAction(sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            processBeginGesture(sender)
        } else if sender.state == .changed {
            processChangedGesture(sender)
        } else if sender.state == .ended || sender.state == .cancelled {
            processEndedOrCancelledGesture(sender)
        }
    }
    
    private func processBeginGesture(_ sender: UIPanGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        containerView.bringSubview(toFront: imageView)
        originCenter = imageView.center
    }
    
    private func processChangedGesture(_ sender: UIPanGestureRecognizer) {
        let current = sender.view as! UIImageView
        let translate = sender.translation(in: self)
        var newCenter = CGPoint(x: current.center.x + translate.x, y: current.center.y + translate.y)
        if newCenter.x <= ItemWidth / 2 + 5 {
            newCenter.x = ItemWidth / 2 + 5
        }
        if newCenter.x >= containerView.frame.size.width - ItemWidth / 2 - 5 {
            newCenter.x = containerView.frame.size.width - ItemWidth / 2 - 5
        }
        
        if newCenter.y <= ItemWidth / 2 + 5 {
            newCenter.y = ItemWidth / 2 + 5
        }
        if newCenter.y >= containerView.frame.size.height - ItemWidth / 2 - 5 {
            newCenter.y = containerView.frame.size.height - ItemWidth / 2 - 5
        }
        current.center = newCenter
        sender.setTranslation(.zero, in: self)
    }
    
    private func processEndedOrCancelledGesture(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: containerView)
        let current = sender.view as! UIImageView
        let find = findInsectRectView(location, current)
        if find == nil {
            UIView.animate(withDuration: 0.2, animations: {
                current.center = self.originCenter
            }, completion: { (finished) in
                
            })
        } else {
            self.exchange(at: find!, with: current)
            UIView.animate(withDuration: 0.2, animations: {
                current.center = find!.center
                find?.center = self.originCenter
            }, completion: { (finished) in
            })
        }
    }
    
    private func reset() {
        originCenter = nil
    }
    
    private func exchange(at obj1: UIImageView, with obj2: UIImageView) {
        let index1 = imageComponents.index(of: obj1)
        let index2 = imageComponents.index(of: obj2)
        imageComponents[index2!] = obj1
        imageComponents[index1!] = obj2
    }
    
    private func findInsectRectView(_ location: CGPoint, _ current: UIImageView) -> UIImageView? {
        for imageView in imageComponents {
            if imageView == current {
                continue
            } else {
                if imageView.frame.contains(location) {
                    return imageView
                } else {
                    continue
                }
            }
        }
        return nil
    }
}

extension Array {
    mutating func exchaneObject(atIndex index1: Int, withObjectAtIndex index2: Int) {
        if index1 < self.count && index2 < self.count {
            let obj1 = self[index1]
            let obj2 = self[index2]
            self[index1] = obj2
            self[index2] = obj1
        }
    }
}
