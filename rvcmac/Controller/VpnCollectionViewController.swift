//
//  VpnCollectionViewController.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa

class VpnCollectionViewController: NSViewController {
    
    let padding: CGFloat = 30

    @IBOutlet weak var collectionView: VpnCollectionView!
    @IBOutlet var collectionViewDataSource: VpnCollectionViewDataSource!
    @IBOutlet var collectionViewDelegate: VpnCollectionViewDelegate!
    
    static func instantiate() -> VpnCollectionViewController {
        let sb = NSStoryboard(name: "Main", bundle: nil)
        return sb.instantiateController(withIdentifier: self.identifier()) as! VpnCollectionViewController
    }

    func assertCheck() {
        assert(collectionView != nil)
        assert(collectionViewDataSource != nil)
        assert(collectionViewDelegate != nil)
        assert(collectionView.dataSource != nil)
        assert(collectionView.delegate != nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertCheck()
        collectionViewDataSource.service = AppDelegate.shared.service
        collectionView.register(NSNib(nibNamed: self.collectionViewDataSource.itemIdentifier, bundle: nil)!, forItemWithIdentifier: self.collectionViewDataSource.itemIdentifier)
        collectionView.enclosingScrollView!.automaticallyAdjustsContentInsets = false
        collectionView.enclosingScrollView!.contentInsets = EdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
    }
    
    var shouldScroll = true

    override func viewWillAppear() {
        let w = view.window!.minSize.width
        let h = self.collectionView.minItemSize.height
        collectionView.minItemSize = NSSize(width: w, height: h)
        if shouldScroll {
            collectionView.enclosingScrollView!.contentView.scroll(NSPoint(x: 0, y: -padding))
            shouldScroll = false
        }
    }

}
