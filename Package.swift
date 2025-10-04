// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LWAspectsHookSwift",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LWAspectsHookSwift",
            targets: ["LWAspectsHookSwift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // Note: Aspects needs to be added as a dependency
        // You may need to create a Swift Package Manager version of Aspects
        // or use a compatible alternative
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LWAspectsHookSwift",
            dependencies: [],
            path: "LWAspectsHook/SwiftClasses",
            exclude: [],
            sources: [
                "AspectInfo.swift",
                "HookConfiguration.swift",
                "HookManager.swift",
                "LWAspectsHookSwift.swift",
                "SwiftUISupport.swift",
                "UIResponder+AspectHook.swift"
            ]
        ),
        .testTarget(
            name: "LWAspectsHookSwiftTests",
            dependencies: ["LWAspectsHookSwift"]),
    ]
)
