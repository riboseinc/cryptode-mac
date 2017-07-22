//
//  VpnCollectionViewItem.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa
import CocoaLumberjack

class VpnCollectionViewItem: NSCollectionViewItem {

    @IBOutlet weak var statusView: NSView!
    @IBOutlet weak var checkBoxButton: NSButton!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var toggleButton: NSButton!
    
    func assertCheck() {
        assert(statusView != nil)
        
        assert(checkBoxButton != nil)
        assert(checkBoxButton.target != nil)
        assert(checkBoxButton.action != nil)
        
        assert(titleTextField != nil)
        
        assert(toggleButton != nil)
        assert(toggleButton.target != nil)
        assert(toggleButton.action != nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        assertCheck()
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        // super.prepareForReuse() leads to a crash
        statusView.backgroundColor = NSColor.ribose.notConnected
        titleTextField.stringValue = ""
        checkBoxButton.state = NSOffState
    }
    
    var item: Vpn! {
        didSet {
            titleTextField.stringValue = item.title
        }
    }
    
    // MARK: - Actions
    
    @IBAction func actionCheckBoxButtonPressed(_ sender: Any) {
        DDLogInfo("\(#function)")
        switch self.checkBoxButton.state {
        case NSOnState:
            DDLogInfo("on")
        default:
            DDLogInfo("off")
        }
    }
    
    @IBAction func actionToggleButtonPressed(_ sender: Any) {
        DDLogInfo("\(#function)")
    }
}
