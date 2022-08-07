# LWAspectsHook

**LWAspectsHook, 实现切面注入，方法Hook相关功能**

[![CI Status](https://img.shields.io/travis/luowei/LWAspectsHook.svg?style=flat)](https://travis-ci.org/luowei/LWAspectsHook)
[![Version](https://img.shields.io/cocoapods/v/LWAspectsHook.svg?style=flat)](https://cocoapods.org/pods/LWAspectsHook)
[![License](https://img.shields.io/cocoapods/l/LWAspectsHook.svg?style=flat)](https://cocoapods.org/pods/LWAspectsHook)
[![Platform](https://img.shields.io/cocoapods/p/LWAspectsHook.svg?style=flat)](https://cocoapods.org/pods/LWAspectsHook)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```Objective-C
+ (void)load {
    [super load];

    [UIResponder setupWithConfiguration:[LWAppDelegate hookEventDict]];
}

+ (NSDictionary *)hookEventDict {
    return @{
            @"LWViewController": @{
                    Hook_TrackedEvents: @[
                            @{
                                    Hook_EventName: @"hookTest方法调用前",
                                    Hook_Option: @(AspectPositionBefore),
                                    Hook_EventSelectorName: @"hookTest:",
                                    Hook_EventHandlerBlock: ^(id <AspectInfo> aspectInfo) {
                                        LWLog(@"========hookTest before hooked =======");
                                        LWLog(@"====== instance:%@  method:%@  arguments:%@ ", aspectInfo.instance, NSStringFromSelector(aspectInfo.originalInvocation.selector), aspectInfo.arguments);
                                    },
                            },
                            @{
                                    Hook_EventName: @"hookTest方法调用后",
                                    Hook_Option: @(AspectPositionAfter),
                                    Hook_EventSelectorName: @"hookTest:",
                                    Hook_EventHandlerBlock: ^(id <AspectInfo> aspectInfo) {
                                        LWLog(@"========hookTest after hooked =======");
                                        id returnVal;
                                        [aspectInfo.originalInvocation getReturnValue:&returnVal];
                                        LWLog(@"====== instance:%@  method:%@  returnVal:%@ ", aspectInfo.instance, NSStringFromSelector(aspectInfo.originalInvocation.selector), returnVal);
                                    },
                            },
                    ],
            },

            @"LWAppDelegate": @{
            }
    };
}

```

## Requirements

## Installation

LWAspectsHook is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LWAspectsHook'
```

**Carthage**
```ruby
github "luowei/LWAspectsHook"
```

```sh
carthage update --platform iOS
# carthage update --no-use-binaries --platform iOS
```

## Author

luowei, luowei@wodedata.com

## License

LWAspectsHook is available under the MIT license. See the LICENSE file for more info.
