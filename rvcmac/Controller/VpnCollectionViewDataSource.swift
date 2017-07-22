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
    
    var items = [
        Vpn(title: "staging.foobar.baz", connect: false, status: .notConnected),
        Vpn(title: "testing.foobar.baz", connect: true, status: .notConnected),
        Vpn(title: "production.foobar.baz", connect: true, status: .connected)
    ]
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: self.itemIdentifier, for: indexPath) as! VpnCollectionViewItem
        item.item = self.items[indexPath.item]
        
        return item
    }

}
