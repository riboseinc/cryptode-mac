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
    
    private let dt: TimeInterval = 1 / 3
    private var requestCooldown: TimeInterval = 2
    private var timeSinceLastRequest: TimeInterval = 0
    
    func startPooling() {
        schedule(dt)
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
        timeSinceLastRequest += dt
        if timeSinceLastRequest > requestCooldown {
            timeSinceLastRequest = 0
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
        let connections = RvcWrapper.list()
        connections.flatMap {RvcWrapper.status($0.name)}.forEach(storage.insert(_:))
        storage.delete(ifMissingIn: Set(connections.map {$0.name}))
        DDLogInfo("Stored connections: \(storage.connections)")
    }

}
