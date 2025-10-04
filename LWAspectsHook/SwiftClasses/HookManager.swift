//
// HookManager.swift
// LWAspectsHook
//
// Created by luowei on 2025-10-03.
// Copyright (c) 2025 luowei. All rights reserved.
//

import Foundation
import Combine

/// A modern Swift manager for handling aspect hooks with SwiftUI support
@available(iOS 13.0, *)
public class HookManager: ObservableObject {

    /// Shared singleton instance
    public static let shared = HookManager()

    /// Published hook events for SwiftUI observation
    @Published public private(set) var hookEvents: [HookEventLog] = []

    /// Maximum number of events to keep in memory
    public var maxEventLogSize: Int = 100

    /// Whether to log hook events
    public var isLoggingEnabled: Bool = false

    private init() {}

    /// Setup hooks with a configuration
    /// - Parameter configuration: The hook configuration to apply
    public func setup(with configuration: HookConfiguration) {
        UIResponder.setup(with: configuration)
    }

    /// Setup hooks with a builder pattern
    /// - Parameter builder: A closure that builds the hook configuration
    public func setup(@HookConfigurationBuilder _ builder: () -> HookConfiguration) {
        let configuration = builder()
        setup(with: configuration)
    }

    /// Log a hook event (internal use)
    internal func logEvent(
        className: String,
        selectorName: String,
        option: HookOption,
        arguments: [Any],
        timestamp: Date = Date()
    ) {
        guard isLoggingEnabled else { return }

        let event = HookEventLog(
            className: className,
            selectorName: selectorName,
            option: option,
            arguments: arguments,
            timestamp: timestamp
        )

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.hookEvents.append(event)

            // Trim if needed
            if self.hookEvents.count > self.maxEventLogSize {
                self.hookEvents.removeFirst(self.hookEvents.count - self.maxEventLogSize)
            }
        }
    }

    /// Clear all logged events
    public func clearEventLog() {
        DispatchQueue.main.async { [weak self] in
            self?.hookEvents.removeAll()
        }
    }
}

/// A log entry for a hook event
public struct HookEventLog: Identifiable {
    public let id = UUID()
    public let className: String
    public let selectorName: String
    public let option: HookOption
    public let arguments: [Any]
    public let timestamp: Date

    public var description: String {
        let optionString: String
        switch option {
        case .before: optionString = "before"
        case .instead: optionString = "instead"
        case .after: optionString = "after"
        }

        return "[\(optionString)] \(className).\(selectorName) - args: \(arguments.count)"
    }
}

// MARK: - Result Builder for Hook Configuration
@resultBuilder
public struct HookConfigurationBuilder {
    public static func buildBlock(_ components: ClassHookConfiguration...) -> HookConfiguration {
        return HookConfiguration(configurations: components)
    }

    public static func buildArray(_ components: [ClassHookConfiguration]) -> HookConfiguration {
        return HookConfiguration(configurations: components)
    }

    public static func buildOptional(_ component: ClassHookConfiguration?) -> [ClassHookConfiguration] {
        if let component = component {
            return [component]
        }
        return []
    }

    public static func buildEither(first component: ClassHookConfiguration) -> ClassHookConfiguration {
        return component
    }

    public static func buildEither(second component: ClassHookConfiguration) -> ClassHookConfiguration {
        return component
    }
}

// MARK: - Convenience Extensions
public extension ClassHookConfiguration {
    /// Create a class hook configuration using a builder
    /// - Parameters:
    ///   - className: The name of the class to hook
    ///   - events: A closure that builds the hook events
    init(className: String, @HookEventBuilder events: () -> [HookEvent]) {
        self.className = className
        self.events = events()
    }
}

@resultBuilder
public struct HookEventBuilder {
    public static func buildBlock(_ components: HookEvent...) -> [HookEvent] {
        return components
    }

    public static func buildArray(_ components: [HookEvent]) -> [HookEvent] {
        return components
    }

    public static func buildOptional(_ component: HookEvent?) -> [HookEvent] {
        if let component = component {
            return [component]
        }
        return []
    }

    public static func buildEither(first component: HookEvent) -> HookEvent {
        return component
    }

    public static func buildEither(second component: HookEvent) -> HookEvent {
        return component
    }
}
