//
//  RvcStatus.swift
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

class RvcStatus: NSObject, Decodable {

    let name: String
    @objc dynamic var status: String
    @objc dynamic var ovpnStatus: String
    @objc dynamic var inTotal: Int
    @objc dynamic var outTotal: Int
    @objc dynamic var timestamp: Int

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

class RvcStatusEnvelope: Decodable {
    
    let code: Int
    let data: RvcStatus
    
    required init(code: Int, data: RvcStatus) {
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
