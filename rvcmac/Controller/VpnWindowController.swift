//
//  VpnWindowController.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa
import CocoaLumberjack

class VpnWindowController: NSWindowController, NSWindowDelegate {

    static func instantiate() -> VpnWindowController {
        let sb = NSStoryboard(name: "Main", bundle: nil)
        return sb.instantiateController(withIdentifier: self.identifier()) as! VpnWindowController
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
}
