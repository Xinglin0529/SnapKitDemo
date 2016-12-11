//
//  DrawingBoard.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/9.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class DrawingBoard: UIView {
    
    fileprivate enum State {
        case begin
        case moved
        case ended
    }
    
    fileprivate var beginPoint: CGPoint = .zero
    fileprivate var endPoint: CGPoint = .zero
    fileprivate var lastPoint: CGPoint = .zero
    fileprivate var state: State = .begin
    fileprivate var image: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        UIGraphicsBeginImageContext(self.bounds.size)
        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        context?.setLineWidth(5)
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        context?.setStrokeColor(UIColor.red.cgColor)
//        context?.move(to: firstPoint)
//        if firstPoint.equalTo(.zero) || currentPoint.equalTo(.zero) {
//            return
//        }
//        context?.addLine(to: currentPoint)
//        context?.closePath()
//        context?.strokePath()
//        UIGraphicsEndImageContext()
    }
}

extension DrawingBoard {
    
    fileprivate func drawImage() {
        
    }
    
    fileprivate func getPoint(touches: Set<UITouch>) -> CGPoint {
        let touch = touches.first
        let point = touch?.location(in: self)
        return point!
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastPoint = .zero
        beginPoint = getPoint(touches: touches)
        endPoint = beginPoint
        state = .begin
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        endPoint = getPoint(touches: touches)
        state = .moved
        self.setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        endPoint = .zero
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        endPoint = getPoint(touches: touches)
        state = .ended
        self.setNeedsDisplay()
    }
}
