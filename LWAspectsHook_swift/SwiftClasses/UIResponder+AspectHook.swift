//
// UIResponder+AspectHook.swift
// LWAspectsHook
//
// Created by luowei on 2025-10-03.
// Copyright (c) 2025 luowei. All rights reserved.
//

import UIKit

/// Logging utility for debug builds
internal func LWLog(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    print("[\(function):\(line)] \(message)")
    #endif
}

/// Extension to UIResponder for setting up aspect hooks
public extension UIResponder {

    /// Setup hooks with a Swift HookConfiguration
    /// - Parameter configuration: The hook configuration to apply
    @objc static func setup(with configuration: HookConfiguration) {
        setup(withConfiguration: configuration.toDictionary())
    }

    /// Setup hooks with a dictionary-based configuration (compatible with Objective-C)
    /// - Parameter configs: Dictionary mapping class names to their hook configurations
    @objc static func setup(withConfiguration configs: [String: Any]) {
        // Hook Events
        for (className, configValue) in configs {
            guard let clazz = NSClassFromString(className) as? NSObject.Type else {
                LWLog("Warning: Class '\(className)' not found")
                continue
            }

            guard let config = configValue as? [String: Any] else {
                LWLog("Warning: Invalid configuration for class '\(className)'")
                continue
            }

            // Process tracked events
            if let trackedEvents = config[HookConfigKeys.trackedEvents] as? [[String: Any]] {
                for event in trackedEvents {
                    guard let selectorName = event[HookConfigKeys.eventSelectorName] as? String else {
                        LWLog("Warning: Missing selector name in event")
                        continue
                    }

                    let selector = NSSelectorFromString(selectorName)

                    guard let handlerBlock = event[HookConfigKeys.eventHandlerBlock] else {
                        LWLog("Warning: Missing handler block for selector '\(selectorName)'")
                        continue
                    }

                    let optionValue = (event[HookConfigKeys.hookOption] as? NSNumber)?.intValue ?? 0

                    do {
                        // Call the Aspects hook method
                        try hookSelector(
                            selector,
                            onClass: clazz,
                            withOptions: optionValue,
                            usingBlock: handlerBlock
                        )
                    } catch {
                        LWLog("Error hooking selector '\(selectorName)' on class '\(className)': \(error)")
                    }
                }
            }
        }
    }

    /// Internal method to perform the actual hooking using Aspects
    /// This needs to be implemented using the Aspects framework
    private static func hookSelector(
        _ selector: Selector,
        onClass clazz: NSObject.Type,
        withOptions options: Int,
        usingBlock block: Any
    ) throws {
        // This is a placeholder that would call into the Aspects framework
        // In a real implementation, this would use aspect_hookSelector:withOptions:usingBlock:error:
        // Since we're creating a Swift wrapper, we assume Aspects is available via Objective-C bridging

        // The actual implementation would look something like:
        // try clazz.aspect_hookSelector(selector, with: AspectOptions(rawValue: UInt(options)), usingBlock: block)

        // For now, we'll use a runtime-based approach that matches the Objective-C version
        let aspectsClass = NSClassFromString("Aspects") as? NSObject.Type
        guard aspectsClass != nil else {
            throw NSError(
                domain: "LWAspectsHook",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Aspects framework not available"]
            )
        }

        // Use performSelector to call the Aspects method
        // This requires that Aspects is properly linked
        let selectorString = "aspect_hookSelector:withOptions:usingBlock:error:"
        let aspectSelector = NSSelectorFromString(selectorString)

        if clazz.responds(to: aspectSelector) {
            var error: NSError?

            // Create invocation for the aspect_hookSelector method
            let methodSignature = clazz.method(for: aspectSelector)
            typealias HookFunction = @convention(c) (AnyClass, Selector, Selector, Int, Any, UnsafeMutablePointer<NSError?>?) -> Any?

            let hookFunc = unsafeBitCast(methodSignature, to: HookFunction.self)
            _ = hookFunc(clazz, aspectSelector, selector, options, block, &error)

            if let error = error {
                throw error
            }
        } else {
            throw NSError(
                domain: "LWAspectsHook",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "Class \(clazz) does not respond to aspect_hookSelector"]
            )
        }
    }
}

// MARK: - Convenience Methods
public extension UIResponder {

    /// Hook a single method on a class
    /// - Parameters:
    ///   - className: The name of the class to hook
    ///   - selectorName: The selector to hook
    ///   - option: When to execute the hook
    ///   - handler: The handler to execute
    @objc static func hook(
        className: String,
        selectorName: String,
        option: HookOption,
        handler: @escaping HookHandlerBlock
    ) {
        let event = HookEvent(
            eventName: "Hook \(selectorName)",
            selectorName: selectorName,
            option: option,
            handlerBlock: handler
        )

        let classConfig = ClassHookConfiguration(
            className: className,
            events: [event]
        )

        let config = HookConfiguration(configurations: [classConfig])
        setup(with: config)
    }
}
