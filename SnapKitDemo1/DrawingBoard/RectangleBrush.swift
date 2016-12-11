//
//  RectangleBrush.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/10.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class RectangleBrush: BaseBrush {
    override func drawInContext(context: CGContext) {
        let x = min(beginPoint.x, endPoint.x)
        let y = min(beginPoint.y, endPoint.y)
        let width = abs(endPoint.x - beginPoint.x)
        let height = abs(endPoint.y - beginPoint.y)
        context.addRect(CGRect(x: x, y: y, width: width, height: height))
    }
}
