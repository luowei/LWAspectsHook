//
// AspectInfo.swift
// LWAspectsHook
//
// Created by luowei on 2025-10-03.
// Copyright (c) 2025 luowei. All rights reserved.
//

import Foundation

/// Protocol that provides information about an aspect hook
@objc public protocol AspectInfo {
    /// The instance that is currently hooked
    var instance: Any { get }

    /// The original invocation of the hooked method
    var originalInvocation: NSInvocation { get }

    /// All method arguments. Will be empty for methods without arguments.
    var arguments: [Any] { get }
}

/// Extension to provide convenient access to selector and return value
public extension AspectInfo {
    /// The selector of the hooked method
    var selector: Selector {
        return originalInvocation.selector
    }

    /// Get the return value from the invocation
    func getReturnValue<T>() -> T? {
        guard originalInvocation.methodSignature.methodReturnLength > 0 else {
            return nil
        }

        var returnValue: T?
        withUnsafeMutablePointer(to: &returnValue) { pointer in
            originalInvocation.getReturnValue(pointer)
        }
        return returnValue
    }
}
