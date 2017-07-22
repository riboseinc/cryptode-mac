//
//  StatusItemDelegate.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa

class StatusItemDelegate: NSObject {
    
    weak var appDelegate: AppDelegate?
    
    func didClick(_ statusBarButton: NSStatusBarButton) {
        print(#function, String(describing: statusBarButton))
    }
    
}
