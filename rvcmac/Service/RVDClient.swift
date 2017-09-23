//
//  RVDClient.swift
//  rvcmac
//
//  Created by Nikita Titov on 17/09/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Foundation
import CocoaLumberjack

let RVCConnectionInsert = NSNotification.Name(rawValue: "RVCConnectionInsert")
let RVCConnectionUpdate = NSNotification.Name(rawValue: "RVCConnectionUpdate")
let RVCConnectionDelete = NSNotification.Name(rawValue: "RVCConnectionDelete")

enum RVDClientError: Error {
    case ServerError(String)
}

class RVDClient {
    
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
            list()
        }
    }
    
    private func list() {
        if let connectionList = rvcList() {
            connectionList.forEach { connection in
                let name = connection.name
                let statusResponse = rvcStatus(name)
                do {
                    let data = statusResponse.data(using: .utf8)!
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let connectionStatusEnvelope = try RVCVpnConnectionStatusEnvelope.decode(json)
                    if connectionStatusEnvelope.code != 0 {
                        throw RVDClientError.ServerError("Error: code=\(connectionStatusEnvelope.code)")
                    }
                    let connectionStatus = connectionStatusEnvelope.data
                    // Handle connection status
                    if !storedConnections.keys.contains(name) {
                        insert(connectionStatus)
                    } else {
                        update(connectionStatus)
                    }
                } catch {
                    DDLogError("\(error)")
                }
            }
            storedConnections.values.forEach { connectionStatus in
                let name = connectionStatus.name
                if nil == connectionList.first { $0.name == name } {
                    delete(name)
                }
            }
        } else {
            storedConnections.values.map { $0.name }.forEach(delete(_:))
        }
        DDLogInfo("Stored connections: \(storedConnections)")
    }
    
    let notificationCenter = NotificationCenter.default
    var storedConnections = [String: RVCVpnConnectionStatus]()
    
    func insert(_ connection: RVCVpnConnectionStatus) {
        storedConnections[connection.name] = connection
        notificationCenter.post(name: RVCConnectionInsert, object: connection)
    }
    
    func update(_ connection: RVCVpnConnectionStatus) {
        //                storedConnections[connection.name] = connection
        //                notificationCenter.post(name: RVCConnectionUpdate, object: connection)
    }
    
    func delete(_ key: String) {
        let connectionStatus = storedConnections.removeValue(forKey: key)!
        notificationCenter.post(name: RVCConnectionDelete, object: connectionStatus)
    }

    // MARK: - Wrappers
    
    private func rvcList() -> [RVCVpnConnection]? {
        var buffer = [Int8]()
        var response: String!
        buffer.withUnsafeMutableBufferPointer { bptr in
            var ptr = bptr.baseAddress!
            rvc_list_connections(1, &ptr)
            response = String(cString: ptr)
        }
        guard let json = jsonObject(response) else {
            return nil
        }
        guard let envelope = try? RVCVpnConnectionEnvelope.decode(json) else {
            return nil
        }
        if envelope.code != 0 {
            return nil
        }
        return envelope.data
    }
    
    private func rvcStatus(_ name: String) -> String {
        var buffer = [Int8]()
        var response: String!
        buffer.withUnsafeMutableBufferPointer { bptr in
            var ptr = bptr.baseAddress!
            rvc_get_status(name.cString(using: .utf8)!, 1, &ptr)
            response = String(cString: ptr)
        }
        return response
    }
    
    private func jsonObject(_ string: String) -> Any? {
        let data = string.data(using: .utf8)!
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }
}
