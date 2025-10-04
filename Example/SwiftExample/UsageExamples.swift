//
// UsageExamples.swift
// LWAspectsHook Swift Example
//
// Created by luowei on 2025-10-03.
// Copyright (c) 2025 luowei. All rights reserved.
//

import SwiftUI

// MARK: - Basic Usage Examples

/// Example 1: Basic hook in UIKit app
class BasicUIKitExample {
    func setup() {
        // Hook a single method
        UIResponder.hook(
            className: "MyViewController",
            selectorName: "viewDidLoad",
            option: .after,
            handler: { aspectInfo in
                print("View controller loaded!")
            }
        )
    }
}

/// Example 2: Multiple hooks on same class
class MultipleHooksExample {
    func setup() {
        let events = [
            HookEvent(
                eventName: "Button Tap Handler",
                selectorName: "buttonTapped:",
                option: .before,
                handlerBlock: { aspectInfo in
                    print("Button is about to be tapped")
                }
            ),
            HookEvent(
                eventName: "Button Tap Complete",
                selectorName: "buttonTapped:",
                option: .after,
                handlerBlock: { aspectInfo in
                    print("Button tap completed")
                }
            )
        ]

        let config = ClassHookConfiguration(
            className: "MyViewController",
            events: events
        )

        UIResponder.setup(with: HookConfiguration(configurations: [config]))
    }
}

// MARK: - SwiftUI Integration Examples

@available(iOS 13.0, *)
/// Example 3: SwiftUI App with hooks
struct SwiftUIAppExample: View {
    var body: some View {
        ContentView()
            .setupHooks {
                ClassHookConfiguration(className: "UIViewController") {
                    HookEvent(
                        eventName: "Track view appearances",
                        selectorName: "viewDidAppear:",
                        option: .after,
                        handlerBlock: { aspectInfo in
                            print("View appeared: \(aspectInfo.instance)")
                        }
                    )
                }
            }
    }
}

@available(iOS 14.0, *)
/// Example 4: Advanced SwiftUI integration with monitoring
struct AdvancedSwiftUIExample: App {
    @StateObject private var hookManager = HookManager.shared

    init() {
        setupAdvancedHooks()
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                MainContentView()
                    .tabItem {
                        Label("Main", systemImage: "house")
                    }

                HookEventMonitorView()
                    .tabItem {
                        Label("Monitor", systemImage: "chart.bar")
                    }
            }
        }
    }

    private func setupAdvancedHooks() {
        hookManager.isLoggingEnabled = true
        hookManager.maxEventLogSize = 500

        hookManager.setup {
            ClassHookConfiguration(className: "UIViewController") {
                HookEvent(
                    eventName: "View Lifecycle - Will Appear",
                    selectorName: "viewWillAppear:",
                    option: .before,
                    handlerBlock: { aspectInfo in
                        print("View will appear: \(type(of: aspectInfo.instance))")
                    }
                )

                HookEvent(
                    eventName: "View Lifecycle - Did Appear",
                    selectorName: "viewDidAppear:",
                    option: .after,
                    handlerBlock: { aspectInfo in
                        print("View did appear: \(type(of: aspectInfo.instance))")
                    }
                )
            }

            ClassHookConfiguration(className: "UIButton") {
                HookEvent(
                    eventName: "Button Send Action",
                    selectorName: "sendAction:to:forEvent:",
                    option: .before,
                    handlerBlock: { aspectInfo in
                        if let args = aspectInfo.arguments as? [Any], args.count >= 1 {
                            print("Button action: \(args[0])")
                        }
                    }
                )
            }
        }
    }
}

struct MainContentView: View {
    var body: some View {
        Text("Main Content")
    }
}

// MARK: - Analytics Integration Example

@available(iOS 13.0, *)
/// Example 5: Analytics tracking using hooks
class AnalyticsHookExample {
    static func setupAnalyticsTracking() {
        HookManager.shared.setup {
            // Track all view controller appearances
            ClassHookConfiguration(className: "UIViewController") {
                HookEvent(
                    eventName: "Screen View Tracking",
                    selectorName: "viewDidAppear:",
                    option: .after,
                    handlerBlock: { aspectInfo in
                        let screenName = String(describing: type(of: aspectInfo.instance))
                        // Send to your analytics service
                        print("Analytics: Screen viewed - \(screenName)")
                    }
                )
            }

            // Track button taps
            ClassHookConfiguration(className: "UIButton") {
                HookEvent(
                    eventName: "Button Tap Tracking",
                    selectorName: "sendAction:to:forEvent:",
                    option: .before,
                    handlerBlock: { aspectInfo in
                        // Track button interaction
                        print("Analytics: Button tapped")
                    }
                )
            }

            // Track network requests (example with URLSession)
            ClassHookConfiguration(className: "NSURLSessionDataTask") {
                HookEvent(
                    eventName: "Network Request Tracking",
                    selectorName: "resume",
                    option: .before,
                    handlerBlock: { aspectInfo in
                        print("Analytics: Network request started")
                    }
                )
            }
        }
    }
}

// MARK: - Debugging Example

@available(iOS 13.0, *)
/// Example 6: Debug logging for development
class DebugLoggingExample {
    static func setupDebugLogging() {
        #if DEBUG
        HookManager.shared.isLoggingEnabled = true

        HookManager.shared.setup {
            ClassHookConfiguration(className: "MyViewController") {
                HookEvent(
                    eventName: "Debug - Method Entry",
                    selectorName: "importantMethod:",
                    option: .before,
                    handlerBlock: { aspectInfo in
                        print("📍 Entering: \(aspectInfo.selector)")
                        print("   Arguments: \(aspectInfo.arguments)")
                    }
                )

                HookEvent(
                    eventName: "Debug - Method Exit",
                    selectorName: "importantMethod:",
                    option: .after,
                    handlerBlock: { aspectInfo in
                        print("📍 Exiting: \(aspectInfo.selector)")
                        if let returnValue: Any = aspectInfo.getReturnValue() {
                            print("   Return value: \(returnValue)")
                        }
                    }
                )
            }
        }
        #endif
    }
}

// MARK: - Method Replacement Example

/// Example 7: Replace method implementation
class MethodReplacementExample {
    static func setupMethodReplacement() {
        let config = ClassHookConfiguration(
            className: "MyCustomClass",
            events: [
                HookEvent(
                    eventName: "Replace calculation",
                    selectorName: "calculate:",
                    option: .instead,
                    handlerBlock: { aspectInfo in
                        print("Custom implementation instead of original")
                        // Optionally call original: aspectInfo.originalInvocation.invoke()
                    }
                )
            ]
        )

        UIResponder.setup(with: HookConfiguration(configurations: [config]))
    }
}

// MARK: - Performance Monitoring Example

@available(iOS 13.0, *)
/// Example 8: Performance monitoring
class PerformanceMonitoringExample {
    static func setupPerformanceMonitoring() {
        var startTimes: [String: Date] = [:]

        HookManager.shared.setup {
            ClassHookConfiguration(className: "MyViewController") {
                HookEvent(
                    eventName: "Performance - Start",
                    selectorName: "expensiveOperation",
                    option: .before,
                    handlerBlock: { aspectInfo in
                        let key = "\(type(of: aspectInfo.instance)).\(aspectInfo.selector)"
                        startTimes[key] = Date()
                    }
                )

                HookEvent(
                    eventName: "Performance - End",
                    selectorName: "expensiveOperation",
                    option: .after,
                    handlerBlock: { aspectInfo in
                        let key = "\(type(of: aspectInfo.instance)).\(aspectInfo.selector)"
                        if let startTime = startTimes[key] {
                            let duration = Date().timeIntervalSince(startTime)
                            print("⏱ \(key) took \(duration)s")
                            startTimes.removeValue(forKey: key)
                        }
                    }
                )
            }
        }
    }
}
