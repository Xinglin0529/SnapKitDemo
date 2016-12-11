//
//  DashLineBrush.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/10.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class DashLineBrush: BaseBrush {
    override func drawInContext(context: CGContext) {
        let lengths: [CGFloat] = [self.strokeWidth * 3, self.strokeWidth * 3]
        context.setLineDash(phase: 2, lengths: lengths)
        context.move(to: beginPoint)
        context.addLine(to: endPoint)
    }
}
