//
//  Vpn.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Foundation

enum VpnStatus {
    case notConnected
    case connecting
    case connected
    case error
}

class Vpn {
    
    let title: String
    let ovpn: String
    var connect: Bool
    var status: VpnStatus
    
    init(title: String, ovpn: String, connect: Bool) {
        self.title = title
        self.ovpn = ovpn
        self.connect = connect
        self.status = .notConnected
    }
    
    static func demo() -> [Vpn] {
        return [
            Vpn(title: "staging.foobar.baz", ovpn: "/Users/test/.setup/vpn/test@foobar.baz-staging.ovpn", connect: false),
            Vpn(title: "testing.foobar.baz", ovpn: "/Users/test/.setup/vpn/test@foobar.baz-testing.ovpn", connect: true),
            Vpn(title: "production.foobar.baz", ovpn: "/Users/test/.setup/vpn/test@foobar.baz-product.ovpn", connect: true)
        ]
    }
}
