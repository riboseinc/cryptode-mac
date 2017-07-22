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
    
    @IBOutlet weak var containerView: NSView!
    
    static func instantiate() -> VpnContainerViewController {
        let sb = NSStoryboard(name: "Main", bundle: nil)
        return sb.instantiateController(withIdentifier: self.identifier()) as! VpnContainerViewController
    }

    func assertCheck() {
        assert(containerView != nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertCheck()
        collection.view.frame = containerView.bounds
        containerView.addSubview(collection.view)
    }
    
}
