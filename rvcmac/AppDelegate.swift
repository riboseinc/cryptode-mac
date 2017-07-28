//
//  AppDelegate.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa
import CocoaLumberjack
import ServiceManagement

fileprivate let helperBundleId = "com.ribose.rvcmac"

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let rootController = VpnContainerViewController.instantiate()
    let popover = VpnPopover()
    let statusItem = NSStatusBar.system().statusItem(withLength: 24)
    let service = try! VpnService()
    let loginItemsController = LoginItemsController()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        func setupLogging() {
            DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console -- ASL is enough on macOS
            DDLog.add(DDASLLogger.sharedInstance) // ASL = Apple System Logs
            
            let fileLogger: DDFileLogger = DDFileLogger() // File Logger
            fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
            fileLogger.logFileManager.maximumNumberOfLogFiles = 7
            DDLog.add(fileLogger)
        }
        setupLogging()
        loginItemsController.add()
        rootController.service = service
        popover.contentViewController = rootController
        statusItem.button!.image = NSImage(named: "rvcmac2")!
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown], handler: { event in
            if self.popover.isShown {
                self.hide(event)
            }
        })
        NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { event -> NSEvent? in
            if event.window == self.statusItem.button!.window {
                self.toggle(sender: self.statusItem.button!)
                return nil
            }
            return event
        }
        DDLogInfo("Start at login is='\(loginItemsController.exists())'")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // MARK: - Utility
    
    private func show(_ sender: NSStatusBarButton) {
        DDLogInfo("\(#function)")
        popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
        popover.contentViewController?.view.window?.makeKey()
        statusItem.button!.highlight(true)
    }
    
    private func hide(_ event: NSEvent?) {
        DDLogInfo("\(#function)")
        popover.performClose(event)
        statusItem.button!.highlight(false)
    }
    
    private func toggle(sender: NSStatusBarButton) {
        DDLogInfo("\(#function)")
        popover.isShown ? hide(nil) : show(sender)
    }
    
//    dynamic var startAtLogin: Bool {
//        get {
//            guard let xs = SMCopyAllJobDictionaries(kSMDomainUserLaunchd).takeRetainedValue() as? [[String:Any]] else {
//                return false
//            }
//            let x = xs.first(where: { $0["Label"] as! String == helperBundleId })
//            return x != nil
//        } set {
//            if SMLoginItemSetEnabled(helperBundleId as CFString, newValue) {
//                DDLogInfo("Successfully set startAtLogin='\(startAtLogin)'")
//            } else {
//                DDLogError("Error: startAtLogin='\(startAtLogin)'. Make sure app is running from /Applications or ~/Applications")
//            }
//        }
//    }
    
    class var shared: AppDelegate {
        return NSApplication.shared().delegate! as! AppDelegate
    }
}
