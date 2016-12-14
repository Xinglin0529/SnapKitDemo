//
//  PanViewController.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/12.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

private let gestureMinimumTranslation: CGFloat = 20.0

enum PanMoveDirection {
    case none, up, down, left, right
}

class PanViewController: UIViewController {
    
    let greenBox = UIView()

    var beginPoint: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        greenBox.backgroundColor = .green
        greenBox.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        self.view.addSubview(greenBox)
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(PanViewController.panGestureRecognizedAction(pan:)))
        greenBox.addGestureRecognizer(panGesture)
        
        let actionSheet = ActionSheet()
        self.view.addSubview(actionSheet)
        actionSheet.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "拼图", style: .plain, target: self, action: #selector(PanViewController.gotoPuzzleController))
    }
    
    @objc private func gotoPuzzleController() {
        self.navigationController?.pushViewController(PuzzleViewController(), animated: true)
    }
    
    @objc private func panGestureRecognizedAction(pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            
        } else if pan.state == .changed {
            let size = pan.view!.frame.size
            let translate = pan.translation(in: pan.view!)
            let deltaX = translate.x
            let deltaY = translate.y
            let center = (pan.view?.center)!
            var centerX = center.x + deltaX
            var centerY = center.y + deltaY
            if centerX <= size.width / 2 {
                centerX = size.width / 2
            }
            if centerX >= self.view.frame.size.width - size.width / 2 {
                centerX = self.view.frame.size.width - size.width / 2
            }
            
            if centerY <= size.height / 2 + 64 {
                centerY = size.height / 2 + 64
            }
            if centerY >= self.view.frame.size.height - size.height / 2 {
                centerY = self.view.frame.size.height - size.height / 2
            }
            
            pan.view?.center = CGPoint(x: centerX, y: centerY)
            pan.setTranslation(CGPoint.zero, in: self.view)
        } else if pan.state == .cancelled || pan.state == .ended {
            var translate = pan.view!.center
            let size = pan.view!.frame.size
            if translate.x < size.width / 2 {
                translate.x = size.width / 2
            }
            if translate.x > self.view.frame.size.width - size.width / 2 {
                translate.x = self.view.frame.size.width - size.width / 2
            }
            
            if translate.y < size.height / 2 + 64 {
                translate.y = size.height / 2 + 64
            }
            
            if translate.y > self.view.frame.size.height - size.height / 2 {
                translate.y = self.view.frame.size.height - size.height / 2
            }
            pan.view?.center = translate
        }
    }
}
