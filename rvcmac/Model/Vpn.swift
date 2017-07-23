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
    case disconnected
    case connecting
    case connected
    case error
}

struct Vpn {
    
    let title: String
    let ovpn: String
    var isSelected: Bool
    var status: VpnStatus
    
    init(title: String, ovpn: String, isSelected: Bool) {
        self.title = title
        self.ovpn = ovpn
        self.isSelected = isSelected
        self.status = .disconnected
    }
    
    mutating func connect() {
        status = .connected
    }

    mutating func disconnect() {
        status = .disconnected
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
            isSelected: json => "connect"
        )
    }

}
