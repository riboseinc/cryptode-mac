//
//  AppDelegate.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem!
    let statusItemDelegate = StatusItemDelegate()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        func createStatusItem() -> NSStatusItem {
            let item = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
            item.image = #imageLiteral(resourceName: "rvcmac")
            item.highlightMode = true
            item.target = self.statusItemDelegate
            item.action = #selector(StatusItemDelegate.didClick(_:))
            return item
        }
        self.statusItemDelegate.appDelegate = self
        self.statusItem = createStatusItem()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    class var shared: AppDelegate {
        return NSApplication.shared().delegate! as! AppDelegate
    }
}
