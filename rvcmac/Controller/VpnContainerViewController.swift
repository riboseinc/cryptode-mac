//
//  VpnContainerViewController.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa
import CocoaLumberjack

class VpnContainerViewController: NSViewController {

    let collection = VpnCollectionViewController.instantiate()
    var service: VpnService!
    
    @IBOutlet weak var headerView: NSVisualEffectView!
    @IBOutlet var menuRef: NSMenu!
    @IBOutlet weak var menuButton: NSButton!
    @IBOutlet weak var connectAllButton: NSButton!
    @IBOutlet weak var disconnectAllButton: NSButton!
    @IBOutlet weak var containerView: NSView!
    
    static func instantiate() -> VpnContainerViewController {
        let sb = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        return sb.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: self.identifier())) as! VpnContainerViewController
    }

    func assertCheck() {
        assert(service != nil)

        assert(headerView != nil)
        
        assert(menuRef != nil)
        
        assert(menuButton != nil)
        assert(menuButton.target != nil)
        assert(menuButton.action != nil)
        
        assert(connectAllButton != nil)
        assert(connectAllButton.action != nil)
        assert(connectAllButton.target != nil)
        
        assert(disconnectAllButton != nil)
        assert(disconnectAllButton.target != nil)
        assert(disconnectAllButton.action != nil)
        
        assert(containerView != nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertCheck()
        collection.view.frame = containerView.bounds
        containerView.addSubview(collection.view, positioned: .below, relativeTo: headerView)
    }
    
    // MARK: - Actions
    
    @IBAction func actionMenu(_ sender: Any) {
        DDLogInfo("\(#function)")
        menuRef.popUp(positioning: nil, at: NSPoint(x: menuButton.bounds.midX + 4, y: 34), in: menuButton)
    }
    
    @IBAction func actionQuit(_ sender: Any) {
        DDLogInfo("\(#function)")
        NSApp.terminate(self)
    }
    
    @IBAction func actionConnectAll(_ sender: Any) {
        DDLogInfo("\(#function)")
        service.connectAll()
        collection.collectionView.reloadData()
    }
    
    @IBAction func actoinDisconnectAll(_ sender: Any) {
        DDLogInfo("\(#function)")
        service.disconnectAll()
        collection.collectionView.reloadData()
    }
}
