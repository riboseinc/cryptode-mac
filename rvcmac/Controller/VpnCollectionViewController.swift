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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        func registerNib() {
            let nib = NSNib(nibNamed: self.collectionViewDataSource.itemIdentifier, bundle: nil)!
            self.collectionView.register(nib, forItemWithIdentifier: self.collectionViewDataSource.itemIdentifier)
        }
        registerNib()
    }
    
    override func viewWillAppear() {
        let w =  view.window!.minSize.width
        let h = self.collectionView.minItemSize.height
        self.collectionView.minItemSize = NSSize(width: w, height: h)
    }

}
