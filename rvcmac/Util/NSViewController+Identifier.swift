//
//  NSViewController+Identifier.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import AppKit

extension NSViewController {
    class func identifier() -> String {
        return String(describing: self)
    }
}

extension NSWindowController {
    class func identifier() -> String {
        return String(describing: self)
    }
}
