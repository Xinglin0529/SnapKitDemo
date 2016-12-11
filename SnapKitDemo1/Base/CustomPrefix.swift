//
//  CustomPrefix.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/11/10.
//  Copyright © 2016年 com. All rights reserved.
//

import Foundation
import UIKit

public protocol UIViewCompatible {
    associatedtype CompatableType
    var yzt: CompatableType { get }
}

public extension UIViewCompatible {
    public var yzt: Auto<Self> {
        get {
            return Auto(self)
        }
        set {}
    }
}

public struct Auto<YZT> {
    public let yzt: YZT
    public init(_ base: YZT) {
        self.yzt = base
    }
}

public extension Auto where YZT: UIView {
    var height: CGFloat {
        set(v) {
            self.yzt.frame.size.height = v
        }
        get {
            return self.yzt.frame.size.height
        }
    }
}

extension UIView: UIViewCompatible {}


internal func Init<Type>(_ value: Type, block: (_  object: Type) -> Void) -> Type {
    block(value)
    return value
}

















