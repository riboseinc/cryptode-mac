//
//  Vpn.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa

class Vpn {
    
    enum Status {
        case notConnected
        case connecting
        case connected
        case error
    }
    
    var title: String
    var connect: Bool
    var status: Status
    
    init(title: String, connect: Bool, status: Status) {
        self.title = title
        self.connect = connect
        self.status = status
    }
}
