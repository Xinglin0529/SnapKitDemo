//
//  LineBrush.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/10.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class LineBrush: BaseBrush {
    override func drawInContext(context: CGContext) {
        context.move(to: beginPoint)
        context.addLine(to: endPoint)
    }
}
