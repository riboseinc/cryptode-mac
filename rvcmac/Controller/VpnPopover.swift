//
//  VpnPopover.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa

class VpnPopover: NSPopover {
    
    override init() {
        super.init()
        animates = false
        appearance = NSAppearance(named: NSAppearanceNameAqua)
//        contentSize = NSSize(width: 320, height: 120)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
