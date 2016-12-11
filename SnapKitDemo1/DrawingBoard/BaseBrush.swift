//
//  BaseBrush.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/10.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit
import CoreGraphics

protocol PaintBrush {
    func supportedContinuousDrawing() -> Bool
    func drawInContext(context: CGContext);
}

class BaseBrush: NSObject, PaintBrush {
    var beginPoint: CGPoint!
    var endPoint: CGPoint!
    var lastPoint: CGPoint?
    
    var strokeWidth: CGFloat!
    
    func supportedContinuousDrawing() -> Bool {
        return false
    }
    
    func drawInContext(context: CGContext) {
        assert(false, "must implements in subClass")
    }
}
