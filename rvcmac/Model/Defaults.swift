//
//  Defaults.swift
//  rvcmac
//
//  Created by Nikita Titov on 24/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import AppKit

fileprivate let KEY_IS_SET_UP = "isSetUp"

class Defaults {
    static var shared = Defaults()
    
    private let userDefaults: UserDefaults
    
    init() {
        self.userDefaults = UserDefaults.standard
        self.userDefaults.register(defaults: [KEY_IS_SET_UP: false])
    }
    
    var isSetUp: Bool {
        get {
            return userDefaults.bool(forKey: KEY_IS_SET_UP)
        }
        set {
            userDefaults.set(newValue, forKey: KEY_IS_SET_UP)
            userDefaults.synchronize()
        }
    }
}
