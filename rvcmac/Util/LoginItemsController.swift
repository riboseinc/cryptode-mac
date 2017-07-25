//
//  LoginItemsController.swift
//  rvcmac
//
//  Created by Nikita Titov on 25/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Foundation

class LoginItemsController {
    
    var appUrl: NSURL {
        get {
            return NSURL(fileURLWithPath: Bundle.main.bundlePath)
        }
    }
    
    func add() {
        add(appUrl)
    }
    
    func remove() {
        remove(appUrl)
    }
    
    func exists() -> Bool {
        return exists(appUrl)
    }
    
    // MARK: - Util
    
    private func loginItems() -> LSSharedFileList? {
        let allocator: CFAllocator! = CFAllocatorGetDefault().takeUnretainedValue()
        let kLoginItems: CFString! = kLSSharedFileListSessionLoginItems.takeUnretainedValue()
        let list = LSSharedFileListCreate(allocator, kLoginItems, nil)
        return list?.takeRetainedValue()
    }
    
    private func existingItem(_ url: NSURL) -> LSSharedFileListItem? {
        guard let loginItems = loginItems() else {
            return nil
        }
        
        var seed: UInt32 = 0
        let currentItems = LSSharedFileListCopySnapshot(loginItems, &seed).takeRetainedValue() as NSArray
        
        for item in currentItems {
            let resolutionFlags: UInt32 = UInt32(kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes)
            let existingUrl = LSSharedFileListItemCopyResolvedURL(item as! LSSharedFileListItem, resolutionFlags, nil).takeRetainedValue() as NSURL
            if existingUrl.isEqual(url) {
                let result = item as! LSSharedFileListItem
                return result
            }
        }
        
        return nil
    }
    
    private func exists(_ url: NSURL) -> Bool {
        return existingItem(url) != nil
    }
    
    private func add(_ url: NSURL) {
        guard let loginItems = loginItems() else {
            return
        }
        if existingItem(url) != nil {
            return
        }
        LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemBeforeFirst.takeUnretainedValue(), nil, nil, url as CFURL, nil, nil)
    }
    
    private func remove(_ url: NSURL) {
        guard let loginItems = loginItems() else {
            return
        }
        guard let item = existingItem(url) else {
            return
        }
        LSSharedFileListItemRemove(loginItems, item)
    }
    
}
