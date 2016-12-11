//
//  Board.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/10.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

enum DrawingState {
    case begin, moved, ended
}

class Board: UIImageView {

    var strokeColor: UIColor
    var strokeWidth: CGFloat
    var brush: BaseBrush?
    
    fileprivate var drawingState: DrawingState!
    fileprivate var realImage: UIImage?
    
    override init(frame: CGRect) {
        self.strokeWidth = 1
        self.strokeColor = .black
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Board {
    
    private func drawingImage() {
        if let brush = self.brush {
            UIGraphicsBeginImageContext(self.bounds.size)
            let context = UIGraphicsGetCurrentContext()
            UIColor.clear.setFill()
            UIRectFill(self.bounds)
            
            context?.setLineCap(.round)
            context?.setLineWidth(self.strokeWidth)
            context?.setStrokeColor(self.strokeColor.cgColor)
            
            if let realImage = self.realImage {
                realImage.draw(in: self.bounds)
            }
            
            brush.strokeWidth = self.strokeWidth
            brush.drawInContext(context: context!)
            context?.strokePath()
            
            let previousImage = UIGraphicsGetImageFromCurrentImageContext()
            if self.drawingState == .ended || brush.supportedContinuousDrawing() {
                self.realImage = previousImage
            }
            
            UIGraphicsEndImageContext()
            self.image = previousImage
            brush.lastPoint = brush.endPoint
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.lastPoint = nil
            brush.beginPoint = touches.first!.location(in: self)
            brush.endPoint = brush.beginPoint
            drawingState = .begin
            drawingImage()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = touches.first!.location(in: self)
            drawingState = .moved
            drawingImage()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = nil
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = touches.first!.location(in: self)
            drawingState = .ended
            drawingImage()
        }
    }
}
