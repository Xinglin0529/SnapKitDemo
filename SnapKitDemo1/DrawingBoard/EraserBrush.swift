//
//  EraserBrush.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/10.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class EraserBrush: PencilBrush {
    override func drawInContext(context: CGContext) {
        context.setBlendMode(.clear)
        super.drawInContext(context: context)
    }
}
