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
        var buffer = [Int8]()
        buffer.withUnsafeMutableBufferPointer { bptr in
            var ptr = bptr.baseAddress!
            rvc_list_connections(1, &ptr)
            handle(String(cString: ptr))
        }
        func handle(_ response: String) {
            do {
                defer {
                    DDLogInfo("Stored connections: \(storedConnections)")
                }
                let data = response.data(using: .utf8)!
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let connectionList = try RVCVpnConnectionList.decode(json)
                if connectionList.code != 0 {
                    throw RVDClientError.ServerError("Error: code=\(connectionList.code)")
                }
                connectionList.data.forEach { connection in
                    let name = connection.name
                    let nameCStr = name.cString(using: .utf8)!
                    var buffer = [Int8]()
                    buffer.withUnsafeMutableBufferPointer { bptr in
                        var ptr = bptr.baseAddress!
                        rvc_get_status(nameCStr, 1, &ptr)
                        let response = String(cString: ptr)
                        do {
                            let data = response.data(using: .utf8)!
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
                }
                storedConnections.values.forEach { connectionStatus in
                    let name = connectionStatus.name
                    if nil == connectionList.data.first { $0.name == name } {
                        delete(name)
                    }
                }
            } catch {
                DDLogError("\(error)")
                storedConnections.values.map { $0.name }.forEach(delete(_:))
            }
        }
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

}
