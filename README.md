# LWAspectsHook

[![CI Status](https://img.shields.io/travis/luowei/LWAspectsHook.svg?style=flat)](https://travis-ci.org/luowei/LWAspectsHook)
[![Version](https://img.shields.io/cocoapods/v/LWAspectsHook.svg?style=flat)](https://cocoapods.org/pods/LWAspectsHook)
[![License](https://img.shields.io/cocoapods/l/LWAspectsHook.svg?style=flat)](https://cocoapods.org/pods/LWAspectsHook)
[![Platform](https://img.shields.io/cocoapods/p/LWAspectsHook.svg?style=flat)](https://cocoapods.org/pods/LWAspectsHook)

[English](./README.md) | [中文版](./README_ZH.md)

## Overview

LWAspectsHook is a lightweight Objective-C library that provides aspect-oriented programming (AOP) capabilities for iOS applications. It allows you to hook into method executions at runtime using a simple configuration-based approach, enabling cross-cutting concerns like logging, analytics, and debugging without modifying existing code.

## Key Features

- **Configuration-Based Hooking** - Define hooks using simple dictionary configurations, making AOP implementation straightforward and maintainable
- **Multiple Hook Positions** - Support for executing code before, after, or instead of original method implementations
- **Type-Safe Blocks** - Use strongly-typed blocks for hook handlers with full access to method context
- **UIResponder Integration** - Seamless setup through UIResponder category extension
- **Method Introspection** - Access method arguments, return values, and invocation details at runtime
- **Built on Aspects** - Leverages the battle-tested [Aspects](https://github.com/steipete/Aspects) library for robust AOP implementation
- **Zero Code Modification** - Hook into methods without modifying existing implementations or breaking encapsulation
- **Flexible Architecture** - Suitable for various use cases including analytics tracking, debugging, logging, and performance monitoring

## Requirements

- iOS 8.0+
- Xcode 8.0+
- Objective-C

## Installation

### CocoaPods

LWAspectsHook is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'LWAspectsHook'
```

Then run:
```bash
pod install
```

### Carthage

Add the following line to your Cartfile:

```ruby
github "luowei/LWAspectsHook"
```

Then run:
```bash
carthage update --platform iOS
```

## Getting Started

### Quick Start

The simplest way to get started with LWAspectsHook is to set up hooks in your AppDelegate or any UIResponder subclass:

```objective-c
#import <LWAspectsHook/LWHookConfig.h>

+ (void)load {
    [super load];
    [UIResponder setupWithConfiguration:[self hookConfiguration]];
}

+ (NSDictionary *)hookConfiguration {
    return @{
        @"YourViewController": @{
            Hook_TrackedEvents: @[
                @{
                    Hook_EventName: @"Before viewDidLoad",
                    Hook_Option: @(AspectPositionBefore),
                    Hook_EventSelectorName: @"viewDidLoad",
                    Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                        NSLog(@"Before viewDidLoad: %@", aspectInfo.instance);
                    }
                }
            ]
        }
    };
}
```

### Understanding Hook Positions

LWAspectsHook supports three hook positions, giving you full control over when your custom code executes:

#### Before (AspectPositionBefore)
Executes your code before the original method runs. Useful for logging, validation, or modifying input parameters.

```objective-c
Hook_Option: @(AspectPositionBefore)
```

#### After (AspectPositionAfter)
Executes your code after the original method completes. Ideal for capturing return values, logging results, or triggering follow-up actions.

```objective-c
Hook_Option: @(AspectPositionAfter)
```

#### Instead (AspectPositionInstead)
Replaces the original method entirely with your implementation. Use this when you need complete control over the method behavior.

```objective-c
Hook_Option: @(AspectPositionInstead)
```

### Working with Method Arguments

Access method arguments through the `aspectInfo.arguments` array. Arguments are automatically boxed as objects:

```objective-c
@{
    Hook_EventSelectorName: @"setTitle:forState:",
    Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
        NSArray *arguments = aspectInfo.arguments;
        NSString *title = arguments[0];  // First argument
        UIControlState state = [arguments[1] integerValue];  // Second argument (boxed)
        NSLog(@"Setting title: %@ for state: %ld", title, (long)state);
    }
}
```

### Capturing Return Values

Use `AspectPositionAfter` to capture and inspect method return values:

```objective-c
@{
    Hook_Option: @(AspectPositionAfter),
    Hook_EventSelectorName: @"calculateResult",
    Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
        id returnValue;
        [aspectInfo.originalInvocation getReturnValue:&returnValue];
        NSLog(@"Method returned: %@", returnValue);

        // You can also perform actions based on the return value
        if ([returnValue integerValue] > 100) {
            NSLog(@"Result exceeds threshold!");
        }
    }
}
```

## Advanced Usage

### Complete Example with Multiple Hooks

Here's a comprehensive example demonstrating multiple hooks on the same method:

```objective-c
+ (NSDictionary *)hookEventDict {
    return @{
        @"LWViewController": @{
            Hook_TrackedEvents: @[
                @{
                    Hook_EventName: @"Before method execution",
                    Hook_Option: @(AspectPositionBefore),
                    Hook_EventSelectorName: @"hookTest:",
                    Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                        NSLog(@"======== hookTest before hooked =======");
                        NSLog(@"Instance: %@, Method: %@, Arguments: %@",
                              aspectInfo.instance,
                              NSStringFromSelector(aspectInfo.originalInvocation.selector),
                              aspectInfo.arguments);
                    }
                },
                @{
                    Hook_EventName: @"After method execution",
                    Hook_Option: @(AspectPositionAfter),
                    Hook_EventSelectorName: @"hookTest:",
                    Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                        NSLog(@"======== hookTest after hooked =======");
                        id returnVal;
                        [aspectInfo.originalInvocation getReturnValue:&returnVal];
                        NSLog(@"Instance: %@, Method: %@, Return Value: %@",
                              aspectInfo.instance,
                              NSStringFromSelector(aspectInfo.originalInvocation.selector),
                              returnVal);
                    }
                }
            ]
        }
    };
}
```

### Common Use Cases

#### Analytics Tracking

```objective-c
@{
    Hook_EventName: @"Track button tap",
    Hook_Option: @(AspectPositionAfter),
    Hook_EventSelectorName: @"buttonTapped:",
    Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
        UIButton *button = aspectInfo.instance;
        [Analytics trackEvent:@"button_tap" properties:@{
            @"button_title": button.titleLabel.text ?: @"Unknown"
        }];
    }
}
```

#### Performance Monitoring

```objective-c
@{
    Hook_EventName: @"Monitor method performance",
    Hook_Option: @(AspectPositionBefore),
    Hook_EventSelectorName: @"performHeavyOperation",
    Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        objc_setAssociatedObject(aspectInfo.instance, @"startTime", @(startTime), OBJC_ASSOCIATION_RETAIN);
    }
},
@{
    Hook_Option: @(AspectPositionAfter),
    Hook_EventSelectorName: @"performHeavyOperation",
    Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
        NSNumber *startTime = objc_getAssociatedObject(aspectInfo.instance, @"startTime");
        CFAbsoluteTime duration = CFAbsoluteTimeGetCurrent() - [startTime doubleValue];
        NSLog(@"Operation took %.4f seconds", duration);
    }
}
```

#### Debugging and Logging

```objective-c
@{
    Hook_EventName: @"Debug network requests",
    Hook_Option: @(AspectPositionBefore),
    Hook_EventSelectorName: @"sendNetworkRequest:",
    Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
        NSDictionary *request = aspectInfo.arguments.firstObject;
        NSLog(@"[DEBUG] Sending request: %@", request);
        #ifdef DEBUG
        // Additional debug-only logging
        NSLog(@"Request headers: %@", request[@"headers"]);
        #endif
    }
}
```

## API Reference

### Configuration Dictionary Structure

The configuration dictionary follows a specific structure for defining hooks:

```objective-c
@{
    @"ClassName": @{
        Hook_TrackedEvents: @[
            @{
                Hook_EventName: @"Description",
                Hook_Option: @(AspectPosition),
                Hook_EventSelectorName: @"methodName:",
                Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                    // Your code here
                }
            }
        ]
    }
}
```

### Configuration Keys

| Key | Type | Description | Required |
|-----|------|-------------|----------|
| `Hook_TrackedEvents` | NSArray | Array of hook event dictionaries | Yes |
| `Hook_EventName` | NSString | Descriptive name for the hook (for documentation/debugging) | Yes |
| `Hook_Option` | NSNumber | Hook position: `AspectPositionBefore`, `AspectPositionAfter`, or `AspectPositionInstead` | Yes |
| `Hook_EventSelectorName` | NSString | Selector name of the method to hook (e.g., "viewDidLoad", "setTitle:forState:") | Yes |
| `Hook_EventHandlerBlock` | Block | Block to execute when hook is triggered. Signature: `^(id<AspectInfo> aspectInfo)` | Yes |

### UIResponder Category

```objective-c
@interface UIResponder(AspectHook)
/// Setup hooks with the provided configuration dictionary
/// @param configs Dictionary mapping class names to their hook configurations
+ (void)setupWithConfiguration:(NSDictionary *)configs;
@end
```

### AspectInfo Protocol

The `AspectInfo` object is passed to your hook handler blocks and provides comprehensive method context:

| Property | Type | Description |
|----------|------|-------------|
| `instance` | id | The object instance being hooked |
| `originalInvocation` | NSInvocation | The NSInvocation object containing method signature, arguments, and return value |
| `arguments` | NSArray | Array of method arguments (automatically boxed for primitive types) |

#### Example: Working with AspectInfo

```objective-c
Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
    // Access the instance
    id targetObject = aspectInfo.instance;

    // Access arguments
    NSArray *args = aspectInfo.arguments;

    // Access method selector
    SEL selector = aspectInfo.originalInvocation.selector;
    NSString *methodName = NSStringFromSelector(selector);

    // Get return value (for AspectPositionAfter)
    id returnValue;
    [aspectInfo.originalInvocation getReturnValue:&returnValue];
}
```

## Example Project

To run the example project and see LWAspectsHook in action:

```bash
git clone https://github.com/luowei/LWAspectsHook.git
cd LWAspectsHook/Example
pod install
open LWAspectsHook.xcworkspace
```

The example project demonstrates:
- Basic hook setup and configuration
- Multiple hook positions (before, after, instead)
- Accessing method arguments and return values
- Real-world use cases for AOP

## Best Practices

### 1. Use Descriptive Event Names
Choose clear, descriptive names for your hooks to make debugging easier:

```objective-c
Hook_EventName: @"Track user login for analytics"  // Good
Hook_EventName: @"Hook1"  // Bad
```

### 2. Keep Hook Handlers Lightweight
Hook handlers should execute quickly to avoid performance issues:

```objective-c
// Good - fast operation
Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
    [Analytics trackEvent:@"view_did_load"];
}

// Avoid - heavy operation in hook
Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
    [self performExpensiveDatabaseOperation];  // Should be async
}
```

### 3. Be Careful with AspectPositionInstead
When using `AspectPositionInstead`, remember to invoke the original implementation if needed:

```objective-c
Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
    // Custom logic before
    NSLog(@"Custom implementation");

    // Invoke original if needed
    [aspectInfo.originalInvocation invoke];
}
```

### 4. Handle Edge Cases
Always validate arguments and handle nil cases:

```objective-c
Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
    if (aspectInfo.arguments.count > 0) {
        id firstArg = aspectInfo.arguments[0];
        if (firstArg) {
            // Safe to use firstArg
        }
    }
}
```

## Troubleshooting

### Common Issues

**Q: My hooks are not being triggered**
- Ensure the class name in the configuration dictionary matches exactly
- Verify the selector name is correct (including colons for parameters)
- Check that `setupWithConfiguration:` is called early enough (e.g., in `+load`)

**Q: App crashes when accessing arguments**
- Make sure you're not accessing array indices that don't exist
- Remember that arguments array doesn't include `self` and `_cmd`

**Q: Return value is always nil**
- Ensure you're using `AspectPositionAfter` when capturing return values
- Some methods have `void` return type and won't have a return value

**Q: Performance degradation after adding hooks**
- Review your hook handler blocks for expensive operations
- Consider moving heavy processing to background threads
- Limit the number of hooks on frequently-called methods

## Dependencies

LWAspectsHook is built on top of:
- [Aspects](https://github.com/steipete/Aspects) - A powerful and battle-tested library for aspect-oriented programming in Objective-C

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## Author

**luowei**
- Email: luowei@wodedata.com
- GitHub: [@luowei](https://github.com/luowei)

## License

LWAspectsHook is available under the MIT license. See the [LICENSE](LICENSE) file for more information.

---

Made with care for the iOS development community. If you find this library helpful, please consider giving it a star on GitHub!
