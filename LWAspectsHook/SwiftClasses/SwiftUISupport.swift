//
// SwiftUISupport.swift
// LWAspectsHook
//
// Created by luowei on 2025-10-03.
// Copyright (c) 2025 luowei. All rights reserved.
//

import SwiftUI

// MARK: - SwiftUI View Modifiers
@available(iOS 13.0, *)
public extension View {
    /// Setup aspect hooks when the view appears
    /// - Parameter configuration: The hook configuration to apply
    /// - Returns: The modified view
    func setupHooks(with configuration: HookConfiguration) -> some View {
        self.onAppear {
            HookManager.shared.setup(with: configuration)
        }
    }

    /// Setup aspect hooks using a builder pattern
    /// - Parameter builder: A closure that builds the hook configuration
    /// - Returns: The modified view
    func setupHooks(@HookConfigurationBuilder _ builder: @escaping () -> HookConfiguration) -> some View {
        self.onAppear {
            HookManager.shared.setup(builder)
        }
    }
}

// MARK: - Hook Event Monitor View
@available(iOS 13.0, *)
public struct HookEventMonitorView: View {
    @ObservedObject private var hookManager = HookManager.shared

    public init() {}

    public var body: some View {
        NavigationView {
            List(hookManager.hookEvents) { event in
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.description)
                        .font(.body)
                    Text(formatDate(event.timestamp))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Hook Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
                        hookManager.clearEventLog()
                    }
                }
            }
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: date)
    }
}

// MARK: - Hook Configuration Preview
@available(iOS 13.0, *)
public struct HookConfigurationPreview: View {
    let configuration: HookConfiguration

    public init(configuration: HookConfiguration) {
        self.configuration = configuration
    }

    public var body: some View {
        List {
            ForEach(configuration.classNames, id: \.self) { className in
                if let classConfig = configuration.configuration(forClassName: className) {
                    Section(header: Text(className)) {
                        ForEach(Array(classConfig.events.enumerated()), id: \.offset) { index, event in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(event.eventName)
                                    .font(.headline)
                                Text("Selector: \(event.selectorName)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("Position: \(optionDescription(event.option))")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .navigationTitle("Hook Configuration")
    }

    private func optionDescription(_ option: HookOption) -> String {
        switch option {
        case .before: return "Before"
        case .instead: return "Instead"
        case .after: return "After"
        }
    }
}

// MARK: - Example SwiftUI App Setup
@available(iOS 14.0, *)
public struct HookSetupModifier: ViewModifier {
    let configuration: HookConfiguration

    public init(configuration: HookConfiguration) {
        self.configuration = configuration
    }

    public func body(content: Content) -> some View {
        content
            .onAppear {
                UIResponder.setup(with: configuration)
            }
    }
}

@available(iOS 14.0, *)
public extension View {
    /// Apply hook setup as a view modifier
    /// - Parameter configuration: The hook configuration to apply
    /// - Returns: The modified view
    func applyHookSetup(_ configuration: HookConfiguration) -> some View {
        self.modifier(HookSetupModifier(configuration: configuration))
    }
}

// MARK: - Debug View for Development
@available(iOS 13.0, *)
public struct HookDebugView: View {
    @ObservedObject private var hookManager = HookManager.shared
    @State private var isLoggingEnabled: Bool = false

    public init() {}

    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Settings")) {
                    Toggle("Enable Logging", isOn: $isLoggingEnabled)
                        .onChange(of: isLoggingEnabled) { value in
                            hookManager.isLoggingEnabled = value
                        }
                }

                Section(header: Text("Statistics")) {
                    HStack {
                        Text("Total Events Logged")
                        Spacer()
                        Text("\(hookManager.hookEvents.count)")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Max Event Log Size")
                        Spacer()
                        Text("\(hookManager.maxEventLogSize)")
                            .foregroundColor(.secondary)
                    }
                }

                Section(header: Text("Actions")) {
                    Button("Clear Event Log") {
                        hookManager.clearEventLog()
                    }

                    NavigationLink("View Events") {
                        HookEventMonitorView()
                    }
                }
            }
            .navigationTitle("Hook Debug")
        }
        .onAppear {
            isLoggingEnabled = hookManager.isLoggingEnabled
        }
    }
}

// MARK: - Preview Helpers
#if DEBUG
@available(iOS 13.0, *)
struct SwiftUISupport_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HookEventMonitorView()
                .previewDisplayName("Event Monitor")

            HookDebugView()
                .previewDisplayName("Debug View")

            HookConfigurationPreview(configuration: sampleConfiguration)
                .previewDisplayName("Configuration Preview")
        }
    }

    static var sampleConfiguration: HookConfiguration {
        HookConfiguration(configurations: [
            ClassHookConfiguration(
                className: "UIViewController",
                events: [
                    HookEvent(
                        eventName: "View Did Load",
                        selectorName: "viewDidLoad",
                        option: .after,
                        handlerBlock: { _ in }
                    )
                ]
            )
        ])
    }
}
#endif
