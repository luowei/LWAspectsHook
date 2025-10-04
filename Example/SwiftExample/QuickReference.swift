//
// QuickReference.swift
// LWAspectsHook Swift - Quick Reference Guide
//
// Created by luowei on 2025-10-03.
// Copyright (c) 2025 luowei. All rights reserved.
//

/*

 QUICK REFERENCE GUIDE FOR LWAspectsHookSwift
 =============================================

 ## Installation

 Add to your Podfile:
 ```ruby
 pod 'LWAspectsHookSwift'
 ```

 ## Import

 ```swift
 import LWAspectsHookSwift
 ```

 ## Basic Usage

 ### 1. Simple Hook (One-liner)

 ```swift
 UIResponder.hook(
     className: "MyViewController",
     selectorName: "viewDidLoad",
     option: .after,
     handler: { aspectInfo in
         print("View loaded!")
     }
 )
 ```

 Or use the convenience API:

 ```swift
 LWHook.setup(
     className: "MyViewController",
     selectorName: "viewDidLoad",
     option: .after,
     handler: { aspectInfo in
         print("View loaded!")
     }
 )
 ```

 ### 2. Multiple Hooks with Configuration

 ```swift
 let configuration = HookConfiguration(configurations: [
     ClassHookConfiguration(
         className: "MyViewController",
         events: [
             HookEvent(
                 eventName: "Before Load",
                 selectorName: "viewDidLoad",
                 option: .before,
                 handlerBlock: { aspectInfo in
                     print("About to load")
                 }
             ),
             HookEvent(
                 eventName: "After Load",
                 selectorName: "viewDidLoad",
                 option: .after,
                 handlerBlock: { aspectInfo in
                     print("Finished loading")
                 }
             )
         ]
     )
 ])

 UIResponder.setup(with: configuration)
 ```

 ### 3. Builder Pattern (iOS 13+)

 ```swift
 HookManager.shared.setup {
     ClassHookConfiguration(className: "MyViewController") {
         HookEvent(
             eventName: "Track Load",
             selectorName: "viewDidLoad",
             option: .after,
             handlerBlock: { aspectInfo in
                 print("Tracked!")
             }
         )
     }
 }
 ```

 Or with LWHook convenience API:

 ```swift
 LWHook.setup {
     ClassHookConfiguration(className: "MyViewController") {
         HookEvent(
             eventName: "Track Load",
             selectorName: "viewDidLoad",
             option: .after,
             handlerBlock: { _ in print("Tracked!") }
         )
     }
 }
 ```

 ## Hook Options

 ```swift
 .before  // Execute before the method
 .instead // Execute instead of the method (replace)
 .after   // Execute after the method
 ```

 ## AspectInfo Protocol

 The handler receives an AspectInfo object with:

 ```swift
 aspectInfo.instance            // The object instance
 aspectInfo.originalInvocation  // NSInvocation object
 aspectInfo.arguments           // Array of arguments
 aspectInfo.selector            // The selector being called
 aspectInfo.getReturnValue<T>() // Get typed return value
 ```

 Example:

 ```swift
 handlerBlock: { aspectInfo in
     // Get arguments
     print("Arguments: \(aspectInfo.arguments)")

     // Get instance
     print("Instance: \(aspectInfo.instance)")

     // Get return value (in .after hook)
     if let returnVal: String = aspectInfo.getReturnValue() {
         print("Returned: \(returnVal)")
     }
 }
 ```

 ## SwiftUI Integration

 ### In Your App

 ```swift
 @main
 struct MyApp: App {
     init() {
         setupHooks()
     }

     var body: some Scene {
         WindowGroup {
             ContentView()
         }
     }

     private func setupHooks() {
         LWHook.setup {
             ClassHookConfiguration(className: "UIViewController") {
                 HookEvent(
                     eventName: "Track Views",
                     selectorName: "viewDidAppear:",
                     option: .after,
                     handlerBlock: { aspectInfo in
                         print("View: \(type(of: aspectInfo.instance))")
                     }
                 )
             }
         }
     }
 }
 ```

 ### View Modifier

 ```swift
 ContentView()
     .setupHooks {
         ClassHookConfiguration(className: "MyClass") {
             HookEvent(
                 eventName: "Hook",
                 selectorName: "myMethod",
                 option: .before,
                 handlerBlock: { _ in print("Hooked!") }
             )
         }
     }
 ```

 ### Debug Views

 ```swift
 // Monitor hook events in real-time
 HookEventMonitorView()

 // Full debug interface
 HookDebugView()

 // Preview configuration
 HookConfigurationPreview(configuration: myConfig)
 ```

 ## Debug Mode

 ### Enable Logging

 ```swift
 HookManager.shared.isLoggingEnabled = true

 // Or use convenience API
 LWHookDebug.enableLogging()
 ```

 ### Clear Logs

 ```swift
 LWHookDebug.clearEventLog()
 ```

 ### Get Event Count

 ```swift
 let count = LWHookDebug.eventCount
 ```

 ## Common Patterns

 ### Analytics Tracking

 ```swift
 LWHook.setup {
     ClassHookConfiguration(className: "UIViewController") {
         HookEvent(
             eventName: "Screen Tracking",
             selectorName: "viewDidAppear:",
             option: .after,
             handlerBlock: { aspectInfo in
                 let screen = String(describing: type(of: aspectInfo.instance))
                 Analytics.track(screen: screen)
             }
         )
     }
 }
 ```

 ### Performance Monitoring

 ```swift
 var startTime: Date?

 LWHook.setup {
     ClassHookConfiguration(className: "MyClass") {
         HookEvent(
             eventName: "Perf Start",
             selectorName: "expensiveMethod",
             option: .before,
             handlerBlock: { _ in startTime = Date() }
         )

         HookEvent(
             eventName: "Perf End",
             selectorName: "expensiveMethod",
             option: .after,
             handlerBlock: { _ in
                 if let start = startTime {
                     let duration = Date().timeIntervalSince(start)
                     print("Duration: \(duration)s")
                 }
             }
         )
     }
 }
 ```

 ### Method Replacement

 ```swift
 LWHook.setup(
     className: "MyClass",
     selectorName: "calculate:",
     option: .instead,
     handler: { aspectInfo in
         print("Custom implementation")
         // Optionally invoke original:
         // aspectInfo.originalInvocation.invoke()
     }
 )
 ```

 ## Migration from Objective-C

 ### Old (Objective-C style):

 ```swift
 let config = [
     "MyViewController": [
         "TrackedEvents": [
             [
                 "EventName": "Load",
                 "HookOption": 2, // .after
                 "EventSelectorName": "viewDidLoad",
                 "EventHandlerBlock": { (info: AspectInfo) in
                     print("Loaded")
                 }
             ]
         ]
     ]
 ]

 UIResponder.setup(withConfiguration: config)
 ```

 ### New (Swift style):

 ```swift
 LWHook.setup {
     ClassHookConfiguration(className: "MyViewController") {
         HookEvent(
             eventName: "Load",
             selectorName: "viewDidLoad",
             option: .after,
             handlerBlock: { _ in print("Loaded") }
         )
     }
 }
 ```

 ### Convert Existing Config:

 ```swift
 let objcConfig = [...] // Your old config
 let swiftConfig = LWMigrationHelper.convertFromObjC(objcConfig)
 UIResponder.setup(with: swiftConfig)
 ```

 ## Tips

 1. Use `.before` for pre-processing, `.after` for post-processing
 2. Use `.instead` to completely replace method behavior
 3. Enable logging during development for debugging
 4. Use HookEventMonitorView to see hooks in action
 5. Keep hook handlers lightweight to avoid performance issues
 6. Remember to use `@objc` on methods you want to hook

 ## Requirements

 - iOS 13.0+ (for SwiftUI features)
 - iOS 8.0+ (for basic features)
 - Swift 5.0+
 - Aspects framework

 */

import Foundation

// This file serves as documentation and can be safely removed from production builds
// It contains no executable code, only documentation comments
