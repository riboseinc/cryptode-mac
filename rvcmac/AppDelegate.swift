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

    var item: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        func setupStatusItem() {
            self.item = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
            self.item.image = #imageLiteral(resourceName: "rvcmac")
            self.item.highlightMode = true
            
            let menu = NSMenu(title: "Menu")
            menu.addItem(NSMenuItem(title: "Item 1", action: nil, keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: "Item 2", action: nil, keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: "Item 3", action: nil, keyEquivalent: ""))
            
            self.item.menu = menu
        }
        setupStatusItem()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    class var shared: AppDelegate {
        return NSApplication.shared().delegate! as! AppDelegate
    }
}
