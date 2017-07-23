//
//  VpnService.swift
//  rvcmac
//
//  Created by Nikita Titov on 23/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Foundation
import CocoaLumberjack

class VpnService {
    var items: [Vpn]
    
    init() throws {
        let url = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "config.json" as CFString, "example" as CFString, nil) as URL
        let data = try Data(contentsOf: url)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        let vpns = try [Vpn].decode(json)
        self.items = vpns
    }
    
    func connectAll() {
        DDLogInfo("\(#function)")
        items.filter { $0.isSelected && !$0.isConnected }.forEach { $0.connect() }
    }
    
    func disconnectAll() {
        DDLogInfo("\(#function)")
        items.forEach { $0.disconnect() }
    }
}
