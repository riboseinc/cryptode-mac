//
//  AppDelegate.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa
import CocoaLumberjack

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem!
    let statusItemDelegate = StatusItemDelegate()
    let windowController = VpnWindowController.instantiate()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        func setupLogging() {
//            DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console -- ASL is enough on macOS
            DDLog.add(DDASLLogger.sharedInstance) // ASL = Apple System Logs
            
            let fileLogger: DDFileLogger = DDFileLogger() // File Logger
            fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
            fileLogger.logFileManager.maximumNumberOfLogFiles = 7
            DDLog.add(fileLogger)
        }
        func createStatusItem() -> NSStatusItem {
            let item = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
            item.image = #imageLiteral(resourceName: "rvcmac")
            item.highlightMode = true
            item.target = self.statusItemDelegate
            item.action = #selector(StatusItemDelegate.didClick(_:))
            return item
        }
        setupLogging()
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
