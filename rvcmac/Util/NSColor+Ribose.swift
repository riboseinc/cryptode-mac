//
//  NSColor+Ribose.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Foundation
import AppKit
import SwiftHEXColors

extension NSColor: RiboseExtensionsProvider {}

extension Ribose where Base: NSColor {
    
    static var disconnected: NSColor {
        return NSColor.clear
    }

    static var connecting: NSColor {
        return NSColor.yellow
    }

    static var connected: NSColor {
        return NSColor.green
    }

    static var error: NSColor {
        return NSColor.red
    }
    
    static var buttonTextNormal: NSColor {
        return NSColor.darkGray
    }
    
    static var buttonTextHighlighted: NSColor {
        return NSColor.black
    }

    static var buttonImageNormal: NSColor {
        return NSColor.darkGray
    }
    
    static var buttonImageHighlighted: NSColor {
        return NSColor.black
    }
    
    static var shadow: NSColor {
        return NSColor.lightGray
    }
    
    static var popover: NSColor {
        return NSColor(hexString: "eeeeee")!
    }
    
}

/// Extenstion proxy inspired by ReactiveCocoa sources
/// Following code copy pasted from ReactiveCocoa4

/// Describes a provider of reactive extensions.
///
/// - note: `RiboseExtensionsProvider` is intended for extensions to types that are not owned
///         by the module in order to avoid name collisions and return type
///         ambiguities.
protocol RiboseExtensionsProvider: class {}

extension RiboseExtensionsProvider {
    /// A proxy which hosts reactive extensions for `self`.
    var ribose: Ribose<Self> {
        return Ribose(self)
    }
    
    /// A proxy which hosts static reactive extensions for the type of `self`.
    static var ribose: Ribose<Self>.Type {
        return Ribose<Self>.self
    }
}

/// A proxy which hosts Ribose extensions of `Base`.
struct Ribose<Base> {
    /// The `Base` instance the extensions would be invoked with.
    let base: Base
    
    /// Construct a proxy
    ///
    /// - parameters:
    ///   - base: The object to be proxied.
    fileprivate init(_ base: Base) {
        self.base = base
    }
}
