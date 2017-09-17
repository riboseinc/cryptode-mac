//
//  RVDClient.swift
//  rvcmac
//
//  Created by Nikita Titov on 17/09/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Foundation

class RVDClient {
    
    var timer: Timer?
    
    deinit {
        timer?.invalidate()
    }
    
    private let dt: TimeInterval = 1 / 30
    private var requestCooldown: Double = 1
    private var timeSinceLastRequest: Double = 0

    func start() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: dt, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func tick() {
        timeSinceLastRequest += dt
        if timeSinceLastRequest > requestCooldown {
            timeSinceLastRequest = 0
            request()
        }
    }
    
    private func request() {
        func handle(_ data: Data?) throws {
            guard let data = data else {
                return
            }
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            let connectionList = try RVCVpnConnectionList.decode(json)
            connectionList.data.forEach { print($0.name) }
        }
        var buffer: [Int8] = []
        buffer.withUnsafeMutableBufferPointer { bptr in
            var ptr = bptr.baseAddress!
            rvc_list_connections(1, &ptr)
            let response = String(cString: ptr)
            do {
                try handle(response.data(using: .utf8))
            } catch {
                print(error)
            }
        }
    }
}
