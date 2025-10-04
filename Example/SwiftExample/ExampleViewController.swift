//
// ExampleViewController.swift
// LWAspectsHook Swift Example
//
// Created by luowei on 2025-10-03.
// Copyright (c) 2025 luowei. All rights reserved.
//

import UIKit

/// Example view controller that demonstrates hook functionality
/// This mirrors the LWViewController from the Objective-C example
@objc class ExampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Call the method that will be hooked
        let result = testMethod("hi")
        print("Result from testMethod: \(result)")
    }

    /// Example method that can be hooked
    /// - Parameter testStr: A test string parameter
    /// - Returns: A response string
    @objc func testMethod(_ testStr: String) -> String {
        var str = "hello world!"
        if testStr == "hi" {
            str = "fine, thank you!"
        }
        return str
    }
}

/// Example of setting up hooks programmatically in Swift
class HookSetupExample {

    /// Example 1: Simple hook setup
    static func setupSimpleHook() {
        UIResponder.hook(
            className: "ExampleViewController",
            selectorName: "testMethod:",
            option: .before,
            handler: { aspectInfo in
                print("Method called with arguments: \(aspectInfo.arguments)")
            }
        )
    }

    /// Example 2: Multiple hooks using configuration
    static func setupMultipleHooks() {
        let configuration = HookConfiguration(configurations: [
            ClassHookConfiguration(
                className: "ExampleViewController",
                events: [
                    HookEvent(
                        eventName: "View Did Load - Before",
                        selectorName: "viewDidLoad",
                        option: .before,
                        handlerBlock: { aspectInfo in
                            print("View controller is about to load")
                        }
                    ),
                    HookEvent(
                        eventName: "View Did Load - After",
                        selectorName: "viewDidLoad",
                        option: .after,
                        handlerBlock: { aspectInfo in
                            print("View controller finished loading")
                        }
                    )
                ]
            )
        ])

        UIResponder.setup(with: configuration)
    }

    /// Example 3: Using builder pattern (iOS 13+)
    @available(iOS 13.0, *)
    static func setupWithBuilder() {
        HookManager.shared.setup {
            ClassHookConfiguration(className: "ExampleViewController") {
                HookEvent(
                    eventName: "Test Method Hook",
                    selectorName: "testMethod:",
                    option: .before,
                    handlerBlock: { aspectInfo in
                        print("Before testMethod")
                    }
                )

                HookEvent(
                    eventName: "Test Method Hook After",
                    selectorName: "testMethod:",
                    option: .after,
                    handlerBlock: { aspectInfo in
                        if let returnValue: String = aspectInfo.getReturnValue() {
                            print("Method returned: \(returnValue)")
                        }
                    }
                )
            }
        }
    }

    /// Example 4: Dictionary-based configuration (compatible with Objective-C)
    static func setupWithDictionary() {
        let config: [String: Any] = [
            "ExampleViewController": [
                "TrackedEvents": [
                    [
                        "EventName": "testMethod before",
                        "HookOption": HookOption.before.rawValue,
                        "EventSelectorName": "testMethod:",
                        "EventHandlerBlock": { (aspectInfo: AspectInfo) in
                            print("Dictionary-based hook: before testMethod")
                        } as HookHandlerBlock
                    ],
                    [
                        "EventName": "testMethod after",
                        "HookOption": HookOption.after.rawValue,
                        "EventSelectorName": "testMethod:",
                        "EventHandlerBlock": { (aspectInfo: AspectInfo) in
                            print("Dictionary-based hook: after testMethod")
                        } as HookHandlerBlock
                    ]
                ]
            ]
        ]

        UIResponder.setup(withConfiguration: config)
    }
}
