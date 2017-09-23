//
//  RvcWrapper.swift
//  rvcmac
//
//  Created by Nikita Titov on 23/09/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Foundation

// Swift wrappers for C library functions.
// Once C functions become mature enough and will do their own parsing from json string to data structures these wrappers could be eliminated.

class RvcWrapper {
    
    static func list() -> [RVCVpnConnection] {
        var buffer = [Int8]()
        var response: String!
        buffer.withUnsafeMutableBufferPointer { bptr in
            var ptr = bptr.baseAddress!
            rvc_list_connections(1, &ptr) // actual library call
            response = String(cString: ptr)
        }
        if let json = jsonObject(response), let envelope = try? RVCVpnConnectionEnvelope.decode(json), envelope.code == 0 {
            return envelope.data
        }
        return [RVCVpnConnection]()
    }
    
    static func status(_ name: String) -> RVCVpnConnectionStatus? {
        var buffer = [Int8]()
        var response: String!
        buffer.withUnsafeMutableBufferPointer { bptr in
            var ptr = bptr.baseAddress!
            rvc_get_status(name.cString(using: .utf8)!, 1, &ptr) // actual library call
            response = String(cString: ptr)
        }
        if let json = jsonObject(response), let envelope = try? RVCVpnConnectionStatusEnvelope.decode(json), envelope.code == 0 {
            return envelope.data
        }
        return nil
    }
    
    private static func jsonObject(_ string: String) -> Any? {
        let data = string.data(using: .utf8)!
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }
}
