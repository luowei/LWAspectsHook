# LWAspectsHook Swift Version

This document describes how to use the Swift/SwiftUI version of LWAspectsHook.

## Overview

LWAspectsHookSwift is a modern Swift/SwiftUI implementation of the LWAspectsHook library. It provides a clean, type-safe API for aspect-oriented programming with full support for Swift-native features and SwiftUI integration.

## Requirements

- iOS 13.0+
- Swift 5.0+
- Xcode 11.0+

## Installation

### CocoaPods

Add the following line to your Podfile:

```ruby
pod 'LWAspectsHookSwift'
```

Then run:
```bash
pod install
```

## Key Features

- **Swift-Native Configuration** - Use structs and enums instead of dictionaries
- **SwiftUI Integration** - View modifiers and observables for SwiftUI apps
- **Result Builders** - Declarative hook setup with Swift result builders
- **Type Safety** - Full type safety with Swift's strong typing system
- **Debug Monitoring** - Built-in SwiftUI views for development and debugging
- **Combine Support** - Integration with Combine framework for reactive programming

## Quick Start

### Basic Hook Setup

```swift
import LWAspectsHookSwift

// Define a hook configuration
let config = HookConfiguration(
    targetClass: ViewController.self,
    selector: #selector(ViewController.viewDidLoad),
    position: .before
) { info in
    print("Before viewDidLoad: \(info.instance)")
}

// Apply the hook
HookManager.shared.apply(config)
```

### SwiftUI Integration

```swift
import SwiftUI
import LWAspectsHookSwift

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .hookOnAppear {
                print("View appeared!")
            }
            .hookOnDisappear {
                print("View disappeared!")
            }
    }
}
```

### Using Result Builders

```swift
HookManager.shared.configure {
    Hook(ViewController.self, #selector(ViewController.viewDidLoad)) {
        print("ViewController loaded")
    }

    Hook(ProfileView.self, #selector(ProfileView.updateProfile(_:))) { info in
        if let profile = info.arguments.first as? Profile {
            print("Updating profile: \(profile.name)")
        }
    }
}
```

## Advanced Usage

### Hook Positions

```swift
// Before original method
let beforeHook = HookConfiguration(
    targetClass: MyClass.self,
    selector: #selector(MyClass.myMethod),
    position: .before
) { info in
    print("Before method execution")
}

// After original method
let afterHook = HookConfiguration(
    targetClass: MyClass.self,
    selector: #selector(MyClass.myMethod),
    position: .after
) { info in
    print("After method execution")
}

// Instead of original method
let insteadHook = HookConfiguration(
    targetClass: MyClass.self,
    selector: #selector(MyClass.myMethod),
    position: .instead
) { info in
    print("Replace original implementation")
    info.originalInvocation.invoke() // Call original if needed
}
```

### Accessing Method Information

```swift
let config = HookConfiguration(
    targetClass: MyViewController.self,
    selector: #selector(MyViewController.updateTitle(_:forState:)),
    position: .before
) { info in
    // Access instance
    let instance = info.instance as? MyViewController

    // Access arguments
    if let title = info.arguments.first as? String,
       let state = info.arguments.last as? UIControl.State {
        print("Setting title: \(title) for state: \(state)")
    }

    // Access selector
    let selectorName = info.selector
}
```

### Debug Monitoring

```swift
import SwiftUI
import LWAspectsHookSwift

struct DebugView: View {
    var body: some View {
        VStack {
            Text("Hook Monitor")
                .font(.headline)

            HookMonitorView()
                .frame(height: 300)
        }
    }
}
```

## SwiftUI-Specific Features

### View Lifecycle Hooks

```swift
struct MyView: View {
    var body: some View {
        VStack {
            Text("Content")
        }
        .hookViewLifecycle { event in
            switch event {
            case .appear:
                print("View appeared")
            case .disappear:
                print("View disappeared")
            }
        }
    }
}
```

### Observable Hook Manager

```swift
import SwiftUI
import LWAspectsHookSwift

class HookViewModel: ObservableObject {
    @Published var hookEvents: [HookEvent] = []

    init() {
        HookManager.shared.eventPublisher
            .sink { [weak self] event in
                self?.hookEvents.append(event)
            }
            .store(in: &cancellables)
    }
}
```

## Best Practices

### 1. Use Type-Safe Configurations

```swift
// Good - Type safe
let config = HookConfiguration(
    targetClass: MyClass.self,
    selector: #selector(MyClass.myMethod(_:)),
    position: .before
) { info in
    // Type-safe handling
}

// Avoid - Using Objective-C style dictionaries
```

### 2. Clean Up Hooks When Needed

```swift
class MyViewController: UIViewController {
    var hookToken: HookToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        hookToken = HookManager.shared.apply(config)
    }

    deinit {
        hookToken?.remove()
    }
}
```

### 3. Use Swift Concurrency

```swift
let config = HookConfiguration(
    targetClass: NetworkManager.self,
    selector: #selector(NetworkManager.fetchData),
    position: .after
) { info in
    Task {
        await logNetworkActivity(info)
    }
}
```

## Migration from Objective-C Version

If you're migrating from the Objective-C version of LWAspectsHook:

### Before (Objective-C)
```objective-c
@{
    @"MyViewController": @{
        Hook_TrackedEvents: @[
            @{
                Hook_EventName: @"Track viewDidLoad",
                Hook_Option: @(AspectPositionBefore),
                Hook_EventSelectorName: @"viewDidLoad",
                Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                    NSLog(@"viewDidLoad hooked");
                }
            }
        ]
    }
}
```

### After (Swift)
```swift
HookConfiguration(
    targetClass: MyViewController.self,
    selector: #selector(MyViewController.viewDidLoad),
    position: .before
) { info in
    print("viewDidLoad hooked")
}
```

## API Reference

### HookConfiguration

```swift
struct HookConfiguration {
    let targetClass: AnyClass
    let selector: Selector
    let position: HookPosition
    let handler: (AspectInfo) -> Void
}
```

### HookPosition

```swift
enum HookPosition {
    case before
    case after
    case instead
}
```

### HookManager

```swift
class HookManager {
    static let shared: HookManager

    func apply(_ configuration: HookConfiguration) -> HookToken
    func configure(@HookBuilder _ builder: () -> [HookConfiguration])
}
```

### AspectInfo

```swift
protocol AspectInfo {
    var instance: Any { get }
    var arguments: [Any] { get }
    var selector: Selector { get }
    var originalInvocation: NSInvocation { get }
}
```

## Examples

Check the `Example/SwiftExample` directory for complete working examples including:

- Basic hook setup
- SwiftUI integration
- Advanced configurations
- Debug monitoring
- Quick reference guide

## Troubleshooting

**Q: Hooks not working in Swift**
- Ensure the method is exposed to Objective-C runtime using `@objc` attribute
- Verify the selector is correctly formed with `#selector()`

**Q: SwiftUI view modifiers not available**
- Make sure you've imported `LWAspectsHookSwift`
- Check iOS deployment target is 13.0 or higher

**Q: Type casting issues**
- Use Swift's type casting (`as?`, `as!`) for arguments
- Remember that primitive types are boxed in NSNumber

## License

LWAspectsHookSwift is available under the MIT license. See the LICENSE file for more information.

## Author

**luowei**
- Email: luowei@wodedata.com
- GitHub: [@luowei](https://github.com/luowei)
