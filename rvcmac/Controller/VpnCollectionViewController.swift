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
        let sb = NSStoryboard(name: .main, bundle: nil)
        return sb.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: self.identifier())) as! VpnCollectionViewController
    }

    deinit {
        NotificationCenter.default.removeObserver(collectionView)
    }
    
    func assertCheck() {
        assert(collectionView != nil)
        assert(collectionViewDataSource != nil)
        assert(collectionViewDelegate != nil)
        assert(collectionView.dataSource != nil)
        assert(collectionView.delegate != nil)
    }
    
    let padding: CGFloat = 30

    override func viewDidLoad() {
        func subscribe() {
            NotificationCenter.default.addObserver(collectionView, selector: #selector(collectionView.reloadData), name: .RvcConnectionInserted, object: nil)
            NotificationCenter.default.addObserver(collectionView, selector: #selector(collectionView.reloadData), name: .RvcConnectionDeleted, object: nil)
        }
        super.viewDidLoad()
        assertCheck()
        collectionViewDataSource.RvdClient = AppDelegate.shared.rvdClient
        collectionView.register(NSNib(nibNamed: NSNib.Name(rawValue: self.collectionViewDataSource.itemIdentifier), bundle: nil)!, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: self.collectionViewDataSource.itemIdentifier))
        collectionView.enclosingScrollView!.automaticallyAdjustsContentInsets = false
        collectionView.enclosingScrollView!.contentInsets = NSEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
        subscribe()
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
