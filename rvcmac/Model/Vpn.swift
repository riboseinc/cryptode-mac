//
//  Vpn.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Foundation
import protocol Decodable.Decodable
import enum Decodable.DecodingError
import Decodable
import CocoaLumberjack

enum VpnStatus {
    case disconnected
    case connecting
    case connected
    case error
}

class Vpn {
    
    let title: String
    let ovpn: String
    var isSelected: Bool
    var status: VpnStatus
    
    var isConnected: Bool {
        get {
            return status == .connected
        }
    }
    
    required init(title: String, ovpn: String, isSelected: Bool) {
        self.title = title
        self.ovpn = ovpn
        self.isSelected = isSelected
        self.status = .disconnected
    }
    
    func connect() {
        status = .connected
    }

    func disconnect() {
        status = .disconnected
    }
    
}

extension Vpn: Decodable {
    
    static func decode(_ json: Any) throws -> Self {
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
        return try self.init(
            title: json => "name",
            ovpn: json => "ovpn",
            isSelected: json => "connect"
        )
    }

}
