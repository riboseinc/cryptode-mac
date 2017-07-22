//
//  Vpn.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Foundation
import Decodable
import CocoaLumberjack

enum VpnStatus {
    case notConnected
    case connecting
    case connected
    case error
}

struct Vpn {
    
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
    
    static func file() -> [Vpn] {
        do {
            let bundle = CFBundleGetMainBundle()
            let name = "config.json" as CFString
            let type = "example" as CFString
            let url = CFBundleCopyResourceURL(bundle, name, type, nil) as URL
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            let vpns = try [Vpn].decode(json)
            DDLogInfo(String(describing: vpns))
            return vpns
        } catch {
            DDLogError(String(describing: error))
            return []
        }
    }
}

extension Vpn: Decodable {
    
    static func decode(_ json: Any) throws -> Vpn {
        Bool.decoder = { json in
            switch json {
            case let str as String where str == "true":
                return true
            case let str as String where str == "false":
                return false
            default:
                return try cast(json)
            }
        }
        return try Vpn(
            title: json => "name",
            ovpn: json => "ovpn",
            connect: json => "connect"
        )
    }

}
