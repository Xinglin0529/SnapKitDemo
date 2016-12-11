//
//  PencilBrush.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/10.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class PencilBrush: BaseBrush {
    override func drawInContext(context: CGContext) {
        if lastPoint != nil {
            context.move(to: lastPoint!)
            context.addLine(to: endPoint)
        } else {
            context.move(to: beginPoint)
            context.addLine(to: endPoint)
        }
    }
    
    override func supportedContinuousDrawing() -> Bool {
        return true
    }
}
