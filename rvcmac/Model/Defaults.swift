//
//  Defaults.swift
//  rvcmac
//
//  Created by Nikita Titov on 24/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import AppKit

class Defaults {
    static var shared = Defaults()
    
    private static let kIsFirstLaunch = "kIsFirstLaunch"
    private let userDefaults: UserDefaults
    
    init() {
        self.userDefaults = UserDefaults.standard
        self.userDefaults.register(defaults: [
            Defaults.kIsFirstLaunch: false
        ])
    }
    
    var isFirstLaunch: Bool {
        get {
            return self.userDefaults.bool(forKey: Defaults.kIsFirstLaunch)
        }
        set {
            self.userDefaults.set(newValue, forKey: Defaults.kIsFirstLaunch)
            self.userDefaults.synchronize()
        }
    }
}
