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
    
    var rvdClient: RVDClient!
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return rvdClient.storage.connections.count
    }
    
    func item(at index: Int) -> RVCVpnConnectionStatus {
        let key = Array(rvdClient.storage.connections.keys)[index]
        let value = rvdClient.storage.connections[key]!
        return value
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let collectionViewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: self.itemIdentifier), for: indexPath) as! VpnCollectionViewItem
        collectionViewItem.item = item(at: indexPath.item)
        
        return collectionViewItem
    }

}
