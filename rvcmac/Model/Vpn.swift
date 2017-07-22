//
//  Vpn.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa

enum VpnStatus {
    case notConnected
    case connecting
    case connected
    case error
}

class Vpn {
    
    let title: String
    var connect: Bool
    var status: VpnStatus
    
    init(title: String, connect: Bool, status: VpnStatus) {
        self.title = title
        self.connect = connect
        self.status = status
    }
    
    static func demo() -> [Vpn] {
        return [
            Vpn(title: "staging.foobar.baz", connect: false, status: .notConnected),
            Vpn(title: "testing.foobar.baz", connect: true, status: .notConnected),
            Vpn(title: "production.foobar.baz", connect: true, status: .connected)
        ]
    }
}
