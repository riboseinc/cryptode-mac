//
//  VpnCollectionViewDataSource.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa

class VpnCollectionViewDataSource: NSObject, NSCollectionViewDataSource {
    
    let itemIdentifier = VpnCollectionViewItem.identifier()
    
    var service: VpnService!
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.service.items.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: self.itemIdentifier, for: indexPath) as! VpnCollectionViewItem
        item.item = self.service.items[indexPath.item]
        
        return item
    }

}
