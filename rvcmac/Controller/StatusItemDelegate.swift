//
//  StatusItemDelegate.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa
import CocoaLumberjack

class StatusItemDelegate: NSObject {
    
    weak var appDelegate: AppDelegate!
    
    func didClick(_ button: NSStatusBarButton) {
        DDLogInfo("\(#function), \(String(describing: button))")
        
        let window = self.appDelegate.windowController.window!

        let windowFrame = window.frame
        let eventFrame = NSApp.currentEvent!.window!.frame

        let origin = NSPoint(
            x: eventFrame.midX - windowFrame.width / 2,
            y: eventFrame.origin.y
        )
        
        window.setFrameTopLeftPoint(origin)
        window.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
    }
    
}
