//
// ExampleApp.swift
// LWAspectsHook Swift Example
//
// Created by luowei on 2025-10-03.
// Copyright (c) 2025 luowei. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
@main
struct ExampleApp: App {
    init() {
        setupHooks()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    private func setupHooks() {
        // Enable logging for development
        HookManager.shared.isLoggingEnabled = true

        // Setup hooks using the builder pattern
        HookManager.shared.setup {
            ClassHookConfiguration(className: "ExampleViewController") {
                HookEvent(
                    eventName: "Hook test method - Before",
                    selectorName: "testMethod:",
                    option: .before,
                    handlerBlock: { aspectInfo in
                        print("========testMethod before hooked =======")
                        print("====== instance: \(aspectInfo.instance)")
                        print("====== method: \(aspectInfo.selector)")
                        print("====== arguments: \(aspectInfo.arguments)")
                    }
                )

                HookEvent(
                    eventName: "Hook test method - After",
                    selectorName: "testMethod:",
                    option: .after,
                    handlerBlock: { aspectInfo in
                        print("========testMethod after hooked =======")
                        print("====== instance: \(aspectInfo.instance)")
                        print("====== method: \(aspectInfo.selector)")

                        // Get return value if available
                        if let returnValue: String = aspectInfo.getReturnValue() {
                            print("====== returnVal: \(returnValue)")
                        }
                    }
                )
            }
        }
    }
}

@available(iOS 14.0, *)
struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                ExampleView()
            }
            .tabItem {
                Label("Example", systemImage: "star")
            }

            HookDebugView()
                .tabItem {
                    Label("Debug", systemImage: "wrench")
                }
        }
    }
}

@available(iOS 14.0, *)
struct ExampleView: View {
    @State private var result: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("LWAspectsHook Swift Example")
                .font(.title)
                .padding()

            Button("Test Hook") {
                // This would call a hooked method
                result = "Hook executed!"
            }
            .buttonStyle(.borderedProminent)

            if !result.isEmpty {
                Text(result)
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
            }

            Spacer()
        }
        .navigationTitle("Example")
    }
}

#if DEBUG
@available(iOS 14.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
