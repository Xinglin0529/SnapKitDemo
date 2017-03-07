//
//  EditorFlowLayout.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 17/3/7.
//  Copyright © 2017年 com. All rights reserved.
//

import UIKit

class EditorFlowLayout: UICollectionViewFlowLayout {
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        return nil
//    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        let centerX: CGFloat = self.collectionView!.contentOffset.x + self.collectionView!.frame.width * 0.5
        for attribute in attributes! {
            let delta: CGFloat = abs(attribute.center.x - centerX)
            let scale: CGFloat = 1.0 - delta / self.collectionView!.frame.width
            attribute.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        }
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var point = proposedContentOffset
        var rect = CGRect.zero
        rect.origin.y = 0
        rect.origin.x = proposedContentOffset.x
        rect.size = self.collectionView!.frame.size
        let array = super.layoutAttributesForElements(in: rect)
        let centerX = proposedContentOffset.x + self.collectionView!.frame.origin.x
        var minDelta: CGFloat = CGFloat(MAXFLOAT)
        for attribute in array! {
            if abs(minDelta) > abs((attribute.center.x - centerX)) {
                minDelta = attribute.center.x
            }
        }
        point.x = point.x + minDelta
        return point
    }
}
