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

    private var observerContext = 0

    @IBOutlet weak var statusView: NSView!
    @IBOutlet weak var checkBoxButton: NSButton!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var toggleButton: TextButton!
    
    var statusToken: NSKeyValueObservation?
    
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
        statusToken?.invalidate()
        statusView.backgroundColor = NSColor.ribose.disconnected
        titleTextField.stringValue = ""
        checkBoxButton.state = .off
    }
    
    var item: RvcStatus! {
        didSet {
            pullStatus()
            pullState()
            pullTitle()
            statusToken = item.observe(\.status) { _, _ in
                self.pullStatus()
            }
        }
    }
    
    // MARK: - UI
    
    private func pullStatus() {
        switch item.status {
        case "DISCONNECTING":
            statusView.backgroundColor = NSColor.ribose.connecting
            toggleButton.text = "Disconnecting..."
            toggleButton.isEnabled = false
        case "DISCONNECTED":
            statusView.backgroundColor = NSColor.ribose.disconnected
            toggleButton.text = "Connect"
            toggleButton.isEnabled = true
        case "CONNECTING":
            statusView.backgroundColor = NSColor.ribose.connecting
            toggleButton.text = "Connecting..."
            toggleButton.isEnabled = false
        case "CONNECTED":
            statusView.backgroundColor = NSColor.ribose.connected
            toggleButton.text = "Disconnect"
            toggleButton.isEnabled = true
        case "ERROR":
            statusView.backgroundColor = NSColor.ribose.error
            toggleButton.text = "Connect"
            toggleButton.isEnabled = true
        default:
            statusView.backgroundColor = NSColor.ribose.disconnected
        }
    }
    
    private func pullState() {
        checkBoxButton.state = item.isSelected ? .on : .off
    }
    
    private func pullTitle() {
        titleTextField.stringValue = item.name
    }
    
    // MARK: - Actions
    
    @IBAction func actionCheckBoxButtonPressed(_ sender: Any) {
        DDLogInfo("\(#function)")
        switch self.checkBoxButton.state {
        case .on:
            DDLogInfo("on")
            item.isSelected = true
        default:
            DDLogInfo("off")
            item.isSelected = false
        }
    }
    
    @IBAction func actionToggleButtonPressed(_ sender: Any) {
        DDLogInfo("\(#function)")
//        if item.isConnected {
//            item.status = .disconnected
//        } else {
//            item.status = .connected
//        }
    }
}
