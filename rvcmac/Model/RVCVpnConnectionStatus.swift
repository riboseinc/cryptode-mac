//
//  RVCVpnConnectionStatus.swift
//  rvcmac
//
//  Created by Nikita Titov on 18/09/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Foundation
import protocol Decodable.Decodable
import enum Decodable.DecodingError
import Decodable
import CocoaLumberjack

// Vpn connection status from `rvc status nmtitov --json`
// Response sample:
//{
//    "code":0,
//    "data":{
//        "name":"nmtitov",
//        "status":"DISCONNECTED",
//        "ovpn-status":"DISCONNECTED",
//        "in-total":0,
//        "out-total":0,
//        "timestamp":1505687032
//    }
//}

class RVCVpnConnectionStatus: Decodable {
    
    let name: String
    let status: String
    let ovpnStatus: String
    let inTotal: Int
    let outTotal: Int
    let timestamp: Int

    required init(name: String, status: String, ovpnStatus: String, inTotal: Int, outTotal: Int, timestamp: Int) {
        self.name = name
        self.status = status
        self.ovpnStatus = ovpnStatus
        self.inTotal = inTotal
        self.outTotal = outTotal
        self.timestamp = timestamp
    }
    
    static func decode(_ json: Any) throws -> Self {
        return try self.init(
            name: json => "name",
            status: json => "status",
            ovpnStatus: json => "ovpn-status",
            inTotal: json => "in-total",
            outTotal: json => "out-total",
            timestamp: json => "timestamp"
        )
    }
    
}

class RVCVpnConnectionStatusEnvelope: Decodable {
    
    let code: Int
    let data: RVCVpnConnectionStatus
    
    required init(code: Int, data: RVCVpnConnectionStatus) {
        self.code = code
        self.data = data
    }
    
    static func decode(_ json: Any) throws -> Self {
        return try self.init(
            code: json => "code",
            data: json => "data"
        )
    }
}
