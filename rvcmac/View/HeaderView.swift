//
//  HeaderView.swift
//  rvcmac
//
//  Created by Nikita Titov on 29/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa

class HeaderView: NSVisualEffectView {

    func configure() {
        wantsLayer = true
        layer!.shadowColor = NSColor.ribose.shadow.cgColor
        layer!.shadowOffset = CGSize(width: 0, height: -1)
        layer!.shadowRadius = 0
        layer!.shadowOpacity = 0.9
        layer!.masksToBounds = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override var wantsDefaultClipping: Bool {
        return false
    }
    
}
