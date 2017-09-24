//
//  VpnWindowController.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa
import CocoaLumberjack

extension NSStoryboard.Name {
    public static let main = NSStoryboard.Name(rawValue: "Main")
}

class VpnWindowController: NSWindowController, NSWindowDelegate {

    static func instantiate() -> VpnWindowController {
        let sb = NSStoryboard(name: .main, bundle: nil)
        return sb.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: self.identifier())) as! VpnWindowController
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
}
