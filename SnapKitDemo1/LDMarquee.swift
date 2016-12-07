//
//  LDMarquee.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/7.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

fileprivate struct MarqueeConfig {
    static let timeInterval: TimeInterval = 3
}

struct MarqueeItem {
    var content: String
    var id: Int
}

class LDMarquee: UIView {
    
    var textFont: CGFloat = 15 {
        willSet {
            marqueeLabel.font = UIFont.systemFont(ofSize: newValue)
        }
    }
    
    var textColor: UIColor = .black {
        willSet {
            marqueeLabel.textColor = newValue
        }
    }
    
    var textAlignment: NSTextAlignment = .left {
        willSet {
            marqueeLabel.textAlignment = newValue
        }
    }
    
    var marqueeBackgroundColor: UIColor = .white {
        willSet {
            self.backgroundColor = newValue
        }
    }
    
    var messages: [MarqueeItem] = [] {
        willSet {
            setupMessages(newValue)
        }
    }
    
    var callback:((Int) -> ())?
    
    fileprivate var currentIndex: Int = 0
    fileprivate var timer: Timer?
    
    fileprivate let marqueeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(marqueeLabel)
        self.clipsToBounds = true
        marqueeLabel.textColor = textColor
        marqueeLabel.font = UIFont.systemFont(ofSize: textFont)
        marqueeLabel.textAlignment = textAlignment
        marqueeLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.addGesture()
    }
    
    private func setupMessages(_ msgs: [MarqueeItem]) {
        if msgs.count == 0 {
            return
        }
        if msgs.count == 1 {
            marqueeLabel.text = getMessage(0, msgs)
            return
        }
        marqueeLabel.text = getMessage(0, msgs)
        addTimer()
    }
    
    fileprivate func getMessage(_ index: Int, _ msgs: [MarqueeItem]) -> String {
        if msgs.count == 0 {
            return ""
        }
        return msgs[index].content
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Add gesture
extension LDMarquee {
    @objc private func tapOnMarquee() {
        if messages.count == 0 {
            return
        }
        if callback != nil {
            callback!(currentIndex)
        }
    }
    
    fileprivate func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(LDMarquee.tapOnMarquee))
        self.addGestureRecognizer(gesture)
    }
}


// MARK: - Add Timer
extension LDMarquee {
    fileprivate func addTimer() {
        removeTimer()
        timer = Timer.scheduledTimer(withTimeInterval: MarqueeConfig.timeInterval, repeats: true, block: { [weak self] (timer) in
            self?.updateMarquee()
        })
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    private func updateMarquee() {
        currentIndex += 1
        if currentIndex == messages.count {
            currentIndex = 0
        }
        marqueeLabel.layer.add(addAnimation(), forKey: "marqueeAnimation")
        marqueeLabel.text = getMessage(currentIndex, messages)
    }
    
    fileprivate func removeTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
}


// MARK: - Add Animation
extension LDMarquee {
    fileprivate func addAnimation() -> CATransition {
        let animation = CATransition()
        animation.duration = 0.4
        animation.fillMode = kCAFillModeRemoved
        animation.isRemovedOnCompletion = true
        animation.type = "push";
        animation.subtype = "fromTop";
        return animation
    }
}
