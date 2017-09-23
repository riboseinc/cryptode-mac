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
    
    var RvdClient: RvdClient!
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return RvdClient.storage.connections.count
    }
    
    func item(at index: Int) -> RvcStatus {
        let key = Array(RvdClient.storage.connections.keys)[index]
        let value = RvdClient.storage.connections[key]!
        return value
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let collectionViewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: self.itemIdentifier), for: indexPath) as! VpnCollectionViewItem
        collectionViewItem.item = item(at: indexPath.item)
        
        return collectionViewItem
    }

}
