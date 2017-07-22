//
//  VpnCollectionViewController.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa

class VpnCollectionViewController: NSViewController {

    @IBOutlet weak var collectionView: VpnCollectionView!
    @IBOutlet var collectionViewDataSource: VpnCollectionViewDataSource!
    @IBOutlet var collectionViewDelegate: VpnCollectionViewDelegate!
    
    static func instantiate() -> VpnCollectionViewController {
        let sb = NSStoryboard(name: "Main", bundle: nil)
        return sb.instantiateController(withIdentifier: self.identifier()) as! VpnCollectionViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(NSNib(nibNamed: self.collectionViewDataSource.itemIdentifier, bundle: nil)!, forItemWithIdentifier: self.collectionViewDataSource.itemIdentifier)
    }
    
    override func viewWillAppear() {
        let w = view.window!.minSize.width
        let h = self.collectionView.minItemSize.height
        self.collectionView.minItemSize = NSSize(width: w, height: h)
    }

}
