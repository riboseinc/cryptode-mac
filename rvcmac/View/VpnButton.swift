//
//  VpnButton.swift
//  rvcmac
//
//  Created by Nikita Titov on 28/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa
import CocoaLumberjack

class VpnButton: NSButton {

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        DDLogInfo("\(#function)")
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        DDLogInfo("\(#function)")
    }
    
}
