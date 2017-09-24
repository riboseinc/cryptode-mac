//
//  RvcWrapper.swift
//  rvcmac
//
//  Created by Nikita Titov on 23/09/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Foundation
import CoreData

// Swift wrappers for C library functions.
// Once C functions become mature enough and will do their own parsing from json string to data structures these wrappers could be eliminated.

class RvcWrapper {
    
    let database: Database
    
    required init(database: Database) {
        self.database = database
    }
    
    func list() -> [RvcConnection] {
        var buffer = [Int8]()
        var response: String!
        buffer.withUnsafeMutableBufferPointer { bptr in
            var ptr = bptr.baseAddress!
            rvc_list_connections(1, &ptr) // actual library call
            response = String(cString: ptr)
        }
        if let json = jsonObject(response), let envelope = try? RvcConnectionEnvelope.decode(json), envelope.code == 0 {
            return envelope.data
        }
        return [RvcConnection]()
    }
    
    func status(_ name: String) -> RvcStatus? {
        var buffer = [Int8]()
        var response: String!
        buffer.withUnsafeMutableBufferPointer { bptr in
            var ptr = bptr.baseAddress!
            rvc_get_status(name.cString(using: .utf8)!, 1, &ptr) // actual library call
            response = String(cString: ptr)
        }
        return createStatus(response)
    }
    
    func connect(_ name: String) -> RvcStatus? {
        var buffer = [Int8]()
        var response: String!
        buffer.withUnsafeMutableBufferPointer { bptr in
            var ptr = bptr.baseAddress!
            let name = name.cString(using: .utf8)!
            rvc_connect(name, 1, &ptr) // actual library call
            response = String(cString: ptr)
        }
        return createStatus(response)
    }
    
    func disconnect(_ name: String) -> RvcStatus? {
        var buffer = [Int8]()
        var response: String!
        buffer.withUnsafeMutableBufferPointer { bptr in
            var ptr = bptr.baseAddress!
            let name = name.cString(using: .utf8)!
            rvc_disconnect(name, 1, &ptr) // actual library call
            response = String(cString: ptr)
        }
        return createStatus(response)
    }
    
    private func createStatus(_ response: String) -> RvcStatus? {
        guard let json = jsonObject(response), let envelope = try? RvcStatusEnvelope.decode(json), envelope.code == 0 else {
            return nil
        }
        let status = envelope.data
        status.connection = database.getConnection(name: status.name)
        return status
    }
    
    private func jsonObject(_ string: String) -> Any? {
        let data = string.data(using: .utf8)!
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }
}
