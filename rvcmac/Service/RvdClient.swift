//
//  RvdClient.swift
//  rvcmac
//
//  Created by Nikita Titov on 17/09/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Foundation
import CocoaLumberjack

class RvdClient {
    
    let storage = Storage()
    var timer: Timer?
    
    deinit {
        timer?.invalidate()
    }
    
    private let dt: TimeInterval = 1 / 30
    private static let poolCooldownDefault: TimeInterval = 1
    private var poolCooldown: TimeInterval = 0
    
    func startPooling() {
        tick()
    }
    
    func schedule(_ delay: TimeInterval) {
        if let timer = timer {
            timer.invalidate()
        }
        let t = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(tick), userInfo: nil, repeats: false)
        RunLoop.current.add(t, forMode: .commonModes)
        timer = t
    }
    
    @objc private func tick() {
        let t1 = Date().timeIntervalSinceNow
        poolCooldown -= dt
        if poolCooldown < 0 {
            pool()
        }
        let t2 = Date().timeIntervalSinceNow
        let diff = t2 - t1
        let delay = dt - diff
        let limitedDelay = max(0, delay)
        
//        DDLogInfo("t1: \(t1)")
//        DDLogInfo("t2: \(t1)")
//        DDLogInfo("diff: \(diff)")
//        DDLogInfo("delay: \(delay)")
//        DDLogInfo("limitedDelay: \(limitedDelay)")

        schedule(limitedDelay)
    }
    
    private func pool() {
        poolCooldown = RvdClient.poolCooldownDefault
        
        let connections = RvcWrapper.list()
        connections.flatMap {RvcWrapper.status($0.name)}.forEach(storage.insert(_:))
        storage.delete(ifMissingIn: Set(connections.map {$0.name}))
        DDLogInfo("Stored connections: \(storage.connections)")
    }

    func connect(_ connection: RvcStatus) {
        if let newConnection = RvcWrapper.connect(connection.name) {
            storage.insert(newConnection)
        }
    }
    
    func disconnect(_ connection: RvcStatus) {
        if let newConnection = RvcWrapper.disconnect(connection.name) {
            storage.insert(newConnection)
        }
    }
}
