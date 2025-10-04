//
// HookConfiguration.swift
// LWAspectsHook
//
// Created by luowei on 2025-10-03.
// Copyright (c) 2025 luowei. All rights reserved.
//

import Foundation

/// Options for when to hook into a method
@objc public enum HookOption: Int {
    /// Hook before the method is called
    case before = 0
    /// Hook instead of the method (replace)
    case instead = 1
    /// Hook after the method is called
    case after = 2
}

/// Type alias for the hook handler closure
public typealias HookHandlerBlock = (AspectInfo) -> Void

/// Configuration for a single hook event
public struct HookEvent {
    /// The name/description of this hook event
    public let eventName: String

    /// The selector name to hook
    public let selectorName: String

    /// When to execute the hook (before, instead, or after)
    public let option: HookOption

    /// The block to execute when the hook is triggered
    public let handlerBlock: HookHandlerBlock

    public init(
        eventName: String,
        selectorName: String,
        option: HookOption,
        handlerBlock: @escaping HookHandlerBlock
    ) {
        self.eventName = eventName
        self.selectorName = selectorName
        self.option = option
        self.handlerBlock = handlerBlock
    }
}

/// Configuration for hooking a specific class
public struct ClassHookConfiguration {
    /// The name of the class to hook
    public let className: String

    /// The events to hook for this class
    public let events: [HookEvent]

    public init(className: String, events: [HookEvent]) {
        self.className = className
        self.events = events
    }
}

/// Main configuration container for all hooks
public struct HookConfiguration {
    /// Dictionary of class names to their hook configurations
    private let configurations: [String: ClassHookConfiguration]

    public init(configurations: [ClassHookConfiguration]) {
        var dict = [String: ClassHookConfiguration]()
        for config in configurations {
            dict[config.className] = config
        }
        self.configurations = dict
    }

    public init(dictionary: [String: ClassHookConfiguration]) {
        self.configurations = dictionary
    }

    /// Get configuration for a specific class
    public func configuration(forClassName className: String) -> ClassHookConfiguration? {
        return configurations[className]
    }

    /// All class names that have configurations
    public var classNames: [String] {
        return Array(configurations.keys)
    }

    /// Convert to dictionary format compatible with Objective-C implementation
    public func toDictionary() -> [String: [String: Any]] {
        var result = [String: [String: Any]]()

        for (className, config) in configurations {
            var eventsArray = [[String: Any]]()

            for event in config.events {
                let eventDict: [String: Any] = [
                    "EventName": event.eventName,
                    "EventSelectorName": event.selectorName,
                    "HookOption": event.option.rawValue,
                    "EventHandlerBlock": event.handlerBlock
                ]
                eventsArray.append(eventDict)
            }

            result[className] = [
                "TrackedEvents": eventsArray
            ]
        }

        return result
    }
}

// MARK: - Dictionary Constants (matching Objective-C version)
public enum HookConfigKeys {
    public static let trackedEvents = "TrackedEvents"
    public static let hookOption = "HookOption"
    public static let eventName = "EventName"
    public static let eventSelectorName = "EventSelectorName"
    public static let eventHandlerBlock = "EventHandlerBlock"
}
