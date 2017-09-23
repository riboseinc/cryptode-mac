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
    public static let RvcConnectionInserted = NSNotification.Name(rawValue: "RvcConnectionInserted")
    public static let RvcConnectionChanged = NSNotification.Name(rawValue: "RvcConnectionChanged")
    public static let RvcConnectionDeleted = NSNotification.Name(rawValue: "RvcConnectionDeleted")
}

class Storage {
    private var _connections = [String: RvcStatus]()
    
    var connections: [String: RvcStatus] {
        get {
            return _connections
        }
    }
    
    func insert(_ connection: RvcStatus) {
        if !_contains(connection.name) {
            _insert(connection)
        } else {
            _update(connection)
        }
    }
    
    func delete(_ key: String) {
        let connection = _connections.removeValue(forKey: key)!
        NotificationCenter.default.post(name: .RvcConnectionDeleted, object: connection)
    }
    
    func delete(ifMissingIn keys: Set<String>) {
        Set(connections.keys).symmetricDifference(keys).forEach(delete(_:))
    }
    
    private func _insert(_ connection: RvcStatus) {
        let key = connection.name
        _connections[key] = connection
        NotificationCenter.default.post(name: .RvcConnectionInserted, object: connection)
    }
    
    private func _update(_ connection: RvcStatus) {
//        storedConnections[connection.name] = connection
//        NotificationCenter.default.post(name: .RvcConnectionChanged, object: connection)
    }
    
    private func _contains(_ key: String) -> Bool {
        return _connections.keys.contains(key)
    }
}
