//
// LWAspectsHookSwift.swift
// LWAspectsHook
//
// Main entry point for the Swift version of LWAspectsHook
// Created by luowei on 2025-10-03.
// Copyright (c) 2025 luowei. All rights reserved.
//

import Foundation

/// Version information
public struct LWAspectsHookSwift {
    public static let version = "1.0.0"
    public static let name = "LWAspectsHookSwift"

    /// Initialize the library (if needed)
    public static func initialize() {
        // Placeholder for any initialization logic
    }
}

// MARK: - Public API Re-exports

// Export all public types for convenient importing
// Users can simply: import LWAspectsHookSwift

/// Re-export AspectInfo protocol
public typealias LWAspectInfo = AspectInfo

/// Re-export HookOption enum
public typealias LWHookOption = HookOption

/// Re-export HookHandlerBlock
public typealias LWHookHandlerBlock = HookHandlerBlock

/// Re-export HookEvent struct
public typealias LWHookEvent = HookEvent

/// Re-export ClassHookConfiguration
public typealias LWClassHookConfiguration = ClassHookConfiguration

/// Re-export HookConfiguration
public typealias LWHookConfiguration = HookConfiguration

// MARK: - Convenience API

/// Global convenience functions for quick setup
public enum LWHook {

    /// Quick setup for a single hook
    /// - Parameters:
    ///   - className: The name of the class to hook
    ///   - selectorName: The selector to hook
    ///   - option: When to execute the hook (before, instead, after)
    ///   - handler: The handler to execute
    public static func setup(
        className: String,
        selectorName: String,
        option: HookOption,
        handler: @escaping HookHandlerBlock
    ) {
        UIResponder.hook(
            className: className,
            selectorName: selectorName,
            option: option,
            handler: handler
        )
    }

    /// Setup hooks with a configuration
    /// - Parameter configuration: The hook configuration
    public static func setup(with configuration: HookConfiguration) {
        UIResponder.setup(with: configuration)
    }

    /// Setup hooks with a dictionary (Objective-C compatible)
    /// - Parameter dictionary: Dictionary configuration
    public static func setup(withDictionary dictionary: [String: Any]) {
        UIResponder.setup(withConfiguration: dictionary)
    }

    @available(iOS 13.0, *)
    /// Setup hooks using a builder
    /// - Parameter builder: Configuration builder closure
    public static func setup(@HookConfigurationBuilder _ builder: () -> HookConfiguration) {
        HookManager.shared.setup(builder)
    }
}

// MARK: - Debug Utilities

public enum LWHookDebug {

    /// Enable debug logging
    @available(iOS 13.0, *)
    public static func enableLogging() {
        HookManager.shared.isLoggingEnabled = true
    }

    /// Disable debug logging
    @available(iOS 13.0, *)
    public static func disableLogging() {
        HookManager.shared.isLoggingEnabled = false
    }

    /// Clear event log
    @available(iOS 13.0, *)
    public static func clearEventLog() {
        HookManager.shared.clearEventLog()
    }

    /// Get current event count
    @available(iOS 13.0, *)
    public static var eventCount: Int {
        return HookManager.shared.hookEvents.count
    }

    /// Set maximum event log size
    @available(iOS 13.0, *)
    public static func setMaxEventLogSize(_ size: Int) {
        HookManager.shared.maxEventLogSize = size
    }
}

// MARK: - Migration Helpers (Objective-C to Swift)

/// Helpers for migrating from Objective-C API to Swift API
public enum LWMigrationHelper {

    /// Convert Objective-C dictionary configuration to Swift HookConfiguration
    /// - Parameter dictionary: The Objective-C style dictionary
    /// - Returns: A Swift HookConfiguration
    public static func convertFromObjC(_ dictionary: [String: Any]) -> HookConfiguration {
        var configurations: [ClassHookConfiguration] = []

        for (className, value) in dictionary {
            guard let classConfig = value as? [String: Any],
                  let trackedEvents = classConfig[HookConfigKeys.trackedEvents] as? [[String: Any]]
            else {
                continue
            }

            var events: [HookEvent] = []

            for eventDict in trackedEvents {
                guard let selectorName = eventDict[HookConfigKeys.eventSelectorName] as? String,
                      let handlerBlock = eventDict[HookConfigKeys.eventHandlerBlock] as? HookHandlerBlock
                else {
                    continue
                }

                let eventName = eventDict[HookConfigKeys.eventName] as? String ?? "Unnamed Event"
                let optionValue = (eventDict[HookConfigKeys.hookOption] as? NSNumber)?.intValue ?? 0
                let option = HookOption(rawValue: optionValue) ?? .before

                let event = HookEvent(
                    eventName: eventName,
                    selectorName: selectorName,
                    option: option,
                    handlerBlock: handlerBlock
                )
                events.append(event)
            }

            if !events.isEmpty {
                configurations.append(ClassHookConfiguration(
                    className: className,
                    events: events
                ))
            }
        }

        return HookConfiguration(configurations: configurations)
    }

    /// Example of Objective-C style configuration
    public static func exampleObjCConfiguration() -> [String: Any] {
        return [
            "MyViewController": [
                HookConfigKeys.trackedEvents: [
                    [
                        HookConfigKeys.eventName: "View Did Load",
                        HookConfigKeys.hookOption: HookOption.after.rawValue,
                        HookConfigKeys.eventSelectorName: "viewDidLoad",
                        HookConfigKeys.eventHandlerBlock: { (aspectInfo: AspectInfo) in
                            print("View loaded")
                        } as HookHandlerBlock
                    ]
                ]
            ]
        ]
    }
}
