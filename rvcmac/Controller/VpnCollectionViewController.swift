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
        let sb = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        return sb.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: self.identifier())) as! VpnCollectionViewController
    }

    deinit {
        unsubscribe()
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
        collectionViewDataSource.rvdClient = AppDelegate.shared.rvdClient
        collectionView.register(NSNib(nibNamed: NSNib.Name(rawValue: self.collectionViewDataSource.itemIdentifier), bundle: nil)!, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: self.collectionViewDataSource.itemIdentifier))
        collectionView.enclosingScrollView!.automaticallyAdjustsContentInsets = false
        collectionView.enclosingScrollView!.contentInsets = NSEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
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
        subscribe()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
    }
    
    // MARK: - Notifications
    
    private let notificationCenter = NotificationCenter.default

    private func subscribe() {
        notificationCenter.addObserver(self, selector: #selector(insert), name: .RvcConnectionInserted, object: nil)
        notificationCenter.addObserver(self, selector: #selector(delete), name: .RvcConnectionDeleted, object: nil)
    }
    
    private func unsubscribe() {
        notificationCenter.removeObserver(self)
    }
    
    @objc private func insert() {
        collectionView.reloadData()
    }
    
    @objc private func delete() {
        collectionView.reloadData()
    }
    
}
