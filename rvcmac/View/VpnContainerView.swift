//
//  VpnContainerView.swift
//  rvcmac
//
//  Created by Nikita Titov on 29/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa

class VpnContainerView: NSView {

    override func viewDidMoveToWindow() {
        guard let frameView = window?.contentView?.superview else {
            return
        }
        
        let backgroundView = NSView(frame: frameView.bounds)
        backgroundView.wantsLayer = true
        backgroundView.layer?.backgroundColor = NSColor.ribose.popover.cgColor
        backgroundView.autoresizingMask = [.width, .height]
        backgroundView.translatesAutoresizingMaskIntoConstraints = true
        
        frameView.addSubview(backgroundView, positioned: .below, relativeTo: frameView)
    }
    
}
