//
//  Defaults.swift
//  rvcmac
//
//  Created by Nikita Titov on 24/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import AppKit

fileprivate let kIsSetUp = "kIsSetUp"

class Defaults {
    static var shared = Defaults()
    
    private let userDefaults: UserDefaults
    
    init() {
        self.userDefaults = UserDefaults.standard
        self.userDefaults.register(defaults: [kIsSetUp: false])
    }
    
    var isSetUp: Bool {
        get {
            return userDefaults.bool(forKey: kIsSetUp)
        }
        set {
            userDefaults.set(newValue, forKey: kIsSetUp)
            userDefaults.synchronize()
        }
    }
}
