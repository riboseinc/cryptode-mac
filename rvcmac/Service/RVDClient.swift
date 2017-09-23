//
//  RVDClient.swift
//  rvcmac
//
//  Created by Nikita Titov on 17/09/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Foundation
import CocoaLumberjack

enum RVDClientError: Error {
    case ServerError(String)
}

class RVDClient {
    
    let storage = Storage()
    var timer: Timer?
    
    deinit {
        timer?.invalidate()
    }
    
    private let dt: TimeInterval = 1 / 30
    private var requestCooldown: Double = 1
    private var timeSinceLastRequest: Double = 0
    
    func startPooling() {
        if timer == nil {
            let t = Timer.scheduledTimer(timeInterval: dt, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
            RunLoop.current.add(t, forMode: .commonModes)
            timer = t
        }
    }
    
    @objc private func tick() {
        timeSinceLastRequest += dt
        if timeSinceLastRequest > requestCooldown {
            timeSinceLastRequest = 0
            pool()
        }
    }
    
    private func pool() {
        let connections = rvcList()
        connections.flatMap {rvcStatus($0.name)}.forEach(storage.insert(_:))
        storage.connections.values.forEach { connection in
            let name = connection.name
            if nil == connections.first { $0.name == name } {
                _ = storage.delete(name)
            }
        }
        DDLogInfo("Stored connections: \(storage.connections)")
    }
    
    // MARK: - Wrappers
    
    // Swift wrappers for C library functions.
    // Once C functions become mature enough and will do their own parsing from json string to data structures these wrappers could be eliminated.
    
    private func rvcList() -> [RVCVpnConnection] {
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
    
    private func rvcStatus(_ name: String) -> RVCVpnConnectionStatus? {
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
    
    private func jsonObject(_ string: String) -> Any? {
        let data = string.data(using: .utf8)!
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }
}
