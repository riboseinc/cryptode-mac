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
    }
    
    var isSetUp: Bool {
        get {
            return self.userDefaults.bool(forKey: kIsSetUp)
        }
        set {
            self.userDefaults.set(newValue, forKey: kIsSetUp)
            self.userDefaults.synchronize()
        }
    }
}
