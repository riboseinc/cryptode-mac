//
//  VpnCollectionView.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa

class VpnCollectionView: NSCollectionView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.minItemSize = NSSize(width: 0, height: 0)
    }

}
