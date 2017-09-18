//
//  RVDClient.swift
//  rvcmac
//
//  Created by Nikita Titov on 17/09/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Foundation

let RVCConnectionInsert = NSNotification.Name(rawValue: "RVCConnectionInsert")
let RVCConnectionDelete = NSNotification.Name(rawValue: "RVCConnectionDelete")
let RVCConnectionUpdate = NSNotification.Name(rawValue: "RVCConnectionUpdate")
let RVCConnectionDeleteAll = NSNotification.Name(rawValue: "RVCConnectionDeleteAll")

class RVDClient {
    
    let notificationCenter = NotificationCenter.default
    var timer: Timer?
    
    deinit {
        timer?.invalidate()
    }
    
    private let dt: TimeInterval = 1 / 30
    private var requestCooldown: Double = 1
    private var timeSinceLastRequest: Double = 0
    
    func start() {
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
            request()
        }
    }
    
    var vpnConnections = [String: RVCVpnConnection]()
    
    private func request() {
        func handle(_ data: Data?) {
            guard let data = data else {
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let connectionList = try RVCVpnConnectionList.decode(json)
                if connectionList.code != 0 {
                    return
                }
                let isEmptyBefore = vpnConnections.isEmpty
                connectionList.data.forEach {
                    let key = $0.name
                    if vpnConnections.keys.contains(key) {
                        notificationCenter.post(name: RVCConnectionUpdate, object: $0)
                        print("Update")
                        vpnConnections[key] = $0
                    } else {
                        notificationCenter.post(name: RVCConnectionInsert, object: $0)
                        print("Insert")
                        vpnConnections[key] = $0
                    }
                }
                vpnConnections.forEach { (k, v) in
                    let first = connectionList.data.first { v.name == $0.name }
                    if first == nil {
                        let connection = vpnConnections.removeValue(forKey: k)
                        notificationCenter.post(name: RVCConnectionDelete, object: connection)
                    }
                }
                
                if isEmptyBefore && !vpnConnections.isEmpty {
                    
                }
                if isEmptyBefore && !vpnConnections.isEmpty {
                    
                }
            } catch {
                vpnConnections.removeAll()
                notificationCenter.post(name: RVCConnectionDeleteAll, object: nil)
                print(error)
            }
            print(vpnConnections)
        }
        var buffer = [Int8]()
        buffer.withUnsafeMutableBufferPointer { bptr in
            var ptr = bptr.baseAddress!
            rvc_list_connections(1, &ptr)
            let response = String(cString: ptr)
            let data = response.data(using: .utf8)
            handle(data)
        }
    }
}
