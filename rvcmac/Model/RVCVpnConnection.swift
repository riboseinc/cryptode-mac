//
//  RVCVpnConnection.swift
//  rvcmac
//
//  Created by Nikita Titov on 17/09/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Foundation
import protocol Decodable.Decodable
import enum Decodable.DecodingError
import Decodable
import CocoaLumberjack

// Vpn connection from `rvc list --json`
// Response sample:
//{
//    "code":0,
//    "data":[
//    {
//    "name":"nmtitov",
//    "profile":"\/Users\/nt\/.rvc\/nmtitov.ovpn",
//    "auto-connect":false,
//    "pre-exec-cmd":"\/usr\/bin\/echo nmtitov"
//    }
//    ]
//}

class RVCVpnConnection: Decodable {
    
    let name: String
    let profile: String
    let autoConnect: Bool
    let preExecCmd: String
    
    required init(name: String, profile: String, autoConnect: Bool, preExecCmd: String) {
        self.name = name
        self.profile = profile
        self.autoConnect = autoConnect
        self.preExecCmd = preExecCmd
    }
    
    static func decode(_ json: Any) throws -> Self {
        return try self.init(
            name: json => "name",
            profile: json => "profile",
            autoConnect: json => "auto-connect",
            preExecCmd: json => "pre-exec-cmd"
        )
    }

}

class RVCVpnConnectionEnvelope: Decodable {
    
    let code: Int
    let data: [RVCVpnConnection]
    
    required init(code: Int, data: [RVCVpnConnection]) {
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
