//
//  ImageButton.swift
//  rvcmac
//
//  Created by Nikita Titov on 28/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa
import CocoaLumberjack

class ImageButton: VpnButton {

    @IBInspectable var displayImage: NSImage!
    
    var view: NSView!
    var imageView: NSImageView!
    
    override func configure() {
        super.configure()
        
        view = {
            let view = NSView(frame: bounds)
            addSubview(view)
            
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: [
                "view": view
                ]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: [
                "view": view
                ]))
            return view
        }()
        
        imageView = {
            let imageView = NSImageView(image: displayImage.tinted(NSColor.ribose.buttonImageNormal))
            imageView.frame = view.bounds
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            
            view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 18))
            view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 18))
            view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0))
            
            return imageView
        }()
    }
    
    override var isPressed: Bool {
        get {
            return super.isPressed
        }
        set {
            super.isPressed = newValue
            if newValue {
                DDLogInfo("Set highlighted")
                imageView.image = displayImage.tinted(NSColor.ribose.buttonImageHighlighted)
            } else {
                DDLogInfo("Set normal")
                imageView.image = displayImage.tinted(NSColor.ribose.buttonImageNormal)
            }
        }
    }
    
}

extension NSImage {
    func tinted(_ color: NSColor) -> NSImage {
        let tinted = self.copy() as! NSImage
        tinted.lockFocus()
        color.set()
        
        let imageRect = NSRect(origin: .zero, size: tinted.size)
        imageRect.fill(using: .sourceAtop)

        tinted.unlockFocus()
        return tinted
    }
}
