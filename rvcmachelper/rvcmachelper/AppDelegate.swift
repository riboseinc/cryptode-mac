//
//  AppDelegate.swift
//  rvcmachelper
//
//  Created by Nikita Titov on 24/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("ping")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        print("pong")
    }

}
