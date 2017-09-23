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
    
    var token: NSKeyValueObservation?
    
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
        token?.invalidate()
        statusView.backgroundColor = NSColor.ribose.disconnected
        titleTextField.stringValue = ""
        checkBoxButton.state = .off
    }
    
    var item: RvcStatus! {
        didSet {
            updateUI()
            token = item.observe(\.status) { _, _ in
                self.updateStatus()
            }
        }
    }
    
    // MARK: - UI
    
    private func updateUI() {
        updateStatus()
        updateState()
        updateTitle()
        updateToggleButton()
    }
    
    private func updateStatus() {
        switch item.status {
        case "DISCONNECTED":
            statusView.backgroundColor = NSColor.ribose.disconnected
        case "CONNECTING":
            statusView.backgroundColor = NSColor.ribose.connecting
        case "CONNECTED":
            statusView.backgroundColor = NSColor.ribose.connected
        case "ERROR":
            statusView.backgroundColor = NSColor.ribose.error
        default:
            statusView.backgroundColor = NSColor.ribose.disconnected
        }
    }
    
    private func updateState() {
//        checkBoxButton.state = item.isSelected ? .on : .off
    }
    
    private func updateTitle() {
        titleTextField.stringValue = item.name
    }
    
    private func updateToggleButton() {
//        if item.isConnected {
//            toggleButton.text = "Disconnect"
//        } else {
//            toggleButton.text = "Connect"
//        }
    }
    
    // MARK: - Actions
    
    @IBAction func actionCheckBoxButtonPressed(_ sender: Any) {
        DDLogInfo("\(#function)")
//        switch self.checkBoxButton.state {
//        case .on:
//            DDLogInfo("on")
//            item.isSelected = true
//        default:
//            DDLogInfo("off")
//            item.isSelected = false
//        }
    }
    
    @IBAction func actionToggleButtonPressed(_ sender: Any) {
        DDLogInfo("\(#function)")
//        if item.isConnected {
//            item.status = .disconnected
//        } else {
//            item.status = .connected
//        }
//        updateStatus()
//        updateToggleButton()
    }
}
