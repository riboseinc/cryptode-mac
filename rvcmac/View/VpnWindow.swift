//
//  VpnWindow.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa

class VpnWindow: NSWindow {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleVisibility = .hidden
    }
    
}
