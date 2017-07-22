//
//  VpnCollectionViewFlowLayout.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa

class VpnCollectionViewFlowLayout: NSCollectionViewFlowLayout {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.minimumInteritemSpacing = CGFloat.greatestFiniteMagnitude
        self.sectionInset = NSEdgeInsetsZero
        self.estimatedItemSize = itemSize
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        let xs = super.layoutAttributesForElements(in: rect)
        for x in xs {
            self.modifyAttributes(x)
        }
        return xs
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        guard let x = super.layoutAttributesForItem(at: indexPath) else {
            return nil
        }
        self.modifyAttributes(x)
        return x
    }
    
    private func modifyAttributes(_ a: NSCollectionViewLayoutAttributes) {
        if let c = collectionView {
            let x = CGFloat(0)
            let y = a.frame.origin.y
            
            let s = (c.collectionViewLayout as? NSCollectionViewFlowLayout)!.sectionInset
            
            let w = c.frame.size.width - (s.left + s.right)
            let h = a.frame.size.height
            
            let r = NSRectToCGRect(NSRect(x: x, y: y, width: w, height: h))
            a.frame = r
        }
    }
}
