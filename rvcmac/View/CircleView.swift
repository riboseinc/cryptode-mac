//
//  CircleView.swift
//  rvcmac
//
//  Created by Nikita Titov on 05/08/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa

class CircleView: NSView {

    override func awakeFromNib() {
        super.awakeFromNib()
        wantsLayer = true
        layer!.cornerRadius = bounds.width / 2
        layer!.masksToBounds = true
    }
    
    override var wantsDefaultClipping: Bool {
        return true
    }
    
}
