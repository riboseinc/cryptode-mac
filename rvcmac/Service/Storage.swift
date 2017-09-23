//
//  Storage.swift
//  rvcmac
//
//  Created by Nikita Titov on 23/09/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Foundation

// Storage is a simple dict wrapper
// It behaves like a set
// For each mutable operation it posts a notificaion
// so that observers could update UI

extension NSNotification.Name {
    public static let RVCConnectionInserted = NSNotification.Name(rawValue: "RVCConnectionInserted")
    public static let RVCConnectionChanged = NSNotification.Name(rawValue: "RVCConnectionChanged")
    public static let RVCConnectionDeleted = NSNotification.Name(rawValue: "RVCConnectionDeleted")
}

class Storage {
    private var _connections = [String: RVCVpnConnectionStatus]()
    
    var connections: [String: RVCVpnConnectionStatus] {
        get {
            return _connections
        }
    }
    
    func insert(_ connection: RVCVpnConnectionStatus) {
        if !_contains(connection.name) {
            _insert(connection)
        } else {
            _update(connection)
        }
    }
    
    func delete(_ key: String) -> RVCVpnConnectionStatus {
        let connection = _connections.removeValue(forKey: key)!
        NotificationCenter.default.post(name: .RVCConnectionDeleted, object: connection)
        return connection
    }
    
    private func _insert(_ connection: RVCVpnConnectionStatus) {
        _connections[connection.name] = connection
        NotificationCenter.default.post(name: .RVCConnectionInserted, object: connection)
    }
    
    private func _update(_ connection: RVCVpnConnectionStatus) {
//        storedConnections[connection.name] = connection
//        NotificationCenter.default.post(name: .RVCConnectionChanged, object: connection)
    }
    
    private func _contains(_ key: String) -> Bool {
        return _connections.keys.contains(key)
    }
}
