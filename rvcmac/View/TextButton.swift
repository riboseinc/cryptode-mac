//
//  TextButton.swift
//  rvcmac
//
//  Created by Nikita Titov on 28/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa

class TextButton: VpnButton {
    
    @IBInspectable var text: String! {
        didSet {
            textField?.stringValue = text
        }
    }
    
    var view: NSView!
    var textField: NSTextField!
    
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
        
        textField = {
            let textField = NSTextField(labelWithString: text)
            textField.font = NSFont.systemFont(ofSize: 11)
            textField.textColor = NSColor.ribose.buttonTextNormal
            textField.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(textField)

            view.addConstraint(NSLayoutConstraint(item: textField, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: textField, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0))
            
            return textField
        }()
    }

    override var isPressed: Bool {
        get {
            return super.isPressed
        }
        set {
            super.isPressed = newValue
            if isPressed {
                textField.textColor = NSColor.ribose.buttonTextHighlighted
            } else {
                textField.textColor = NSColor.ribose.buttonTextNormal
            }
        }
    }
}
