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
    
    let notificationCenter = NotificationCenter.default
    var storedConnections = [String: RVCVpnConnection]()
    
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
                    if !storedConnections.keys.contains(connection.name) {
                        insert(connection)
                    } else {
                        update(connection)
                    }
                }
                storedConnections.values.forEach { connection in
                    if nil == connectionList.data.first { $0.name == connection.name } {
                        delete(connection)
                    }
                }
            } catch {
                DDLogError("\(error)")
                storedConnections.values.forEach { connection in
                    delete(connection)
                }
            }
            func insert(_ connection: RVCVpnConnection) {
                storedConnections[connection.name] = connection
                notificationCenter.post(name: RVCConnectionInsert, object: connection)
            }
            func update(_ connection: RVCVpnConnection) {
//                storedConnections[connection.name] = connection
//                notificationCenter.post(name: RVCConnectionUpdate, object: connection)
            }
            func delete(_ connection: RVCVpnConnection) {
                storedConnections.removeValue(forKey: connection.name)
                notificationCenter.post(name: RVCConnectionDelete, object: nil)
            }
        }
    }
}
