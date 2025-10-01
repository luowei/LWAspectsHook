# LWAspectsHook

[![CI Status](https://img.shields.io/travis/luowei/LWAspectsHook.svg?style=flat)](https://travis-ci.org/luowei/LWAspectsHook)
[![Version](https://img.shields.io/cocoapods/v/LWAspectsHook.svg?style=flat)](https://cocoapods.org/pods/LWAspectsHook)
[![License](https://img.shields.io/cocoapods/l/LWAspectsHook.svg?style=flat)](https://cocoapods.org/pods/LWAspectsHook)
[![Platform](https://img.shields.io/cocoapods/p/LWAspectsHook.svg?style=flat)](https://cocoapods.org/pods/LWAspectsHook)

[English Documentation](README.md)

## 项目描述

LWAspectsHook 是一个轻量级的 Objective-C 库，为 iOS 应用程序提供面向切面编程（AOP）功能。它允许你使用简单的配置方式在运行时钩入方法执行，实现日志记录、分析统计和调试等横切关注点，而无需修改现有代码。

## 功能特性

- **基于配置的钩子**: 使用简单的字典配置定义钩子
- **多种钩子位置**: 支持方法执行前、执行后和替代执行的钩子位置
- **类型安全的 Block**: 使用强类型 Block 作为钩子处理器
- **UIResponder 集成**: 通过 UIResponder 分类轻松设置
- **方法自省**: 访问方法参数和返回值
- **基于 Aspects**: 利用强大的 Aspects 库构建
- **零代码修改**: 无需修改现有实现即可钩入方法

## 系统要求

- iOS 8.0+
- Xcode 8.0+
- Objective-C

## 安装方法

### CocoaPods

LWAspectsHook 可通过 [CocoaPods](https://cocoapods.org) 安装。只需在 Podfile 中添加以下行：

```ruby
pod 'LWAspectsHook'
```

然后运行：
```bash
pod install
```

### Carthage

在 Cartfile 中添加以下行：

```ruby
github "luowei/LWAspectsHook"
```

然后运行：
```bash
carthage update --platform iOS
```

## 使用方法

### 基本设置

在你的 AppDelegate 或任何 UIResponder 子类中设置钩子：

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
                    Hook_EventName: @"viewDidLoad 方法执行前",
                    Hook_Option: @(AspectPositionBefore),
                    Hook_EventSelectorName: @"viewDidLoad",
                    Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                        NSLog(@"viewDidLoad 执行前: %@", aspectInfo.instance);
                    }
                }
            ]
        }
    };
}
```

### 钩子位置

LWAspectsHook 支持三种钩子位置：

```objective-c
// 在原方法执行前执行
Hook_Option: @(AspectPositionBefore)

// 在原方法执行后执行
Hook_Option: @(AspectPositionAfter)

// 替代原方法执行
Hook_Option: @(AspectPositionInstead)
```

### 访问方法参数

```objective-c
@{
    Hook_EventSelectorName: @"setTitle:forState:",
    Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
        NSArray *arguments = aspectInfo.arguments;
        NSString *title = arguments[0];
        UIControlState state = [arguments[1] integerValue];
        NSLog(@"设置标题: %@，状态: %ld", title, (long)state);
    }
}
```

### 访问返回值

```objective-c
@{
    Hook_Option: @(AspectPositionAfter),
    Hook_EventSelectorName: @"calculateResult",
    Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
        id returnValue;
        [aspectInfo.originalInvocation getReturnValue:&returnValue];
        NSLog(@"方法返回值: %@", returnValue);
    }
}
```

### 完整示例

```objective-c
+ (NSDictionary *)hookEventDict {
    return @{
        @"LWViewController": @{
            Hook_TrackedEvents: @[
                @{
                    Hook_EventName: @"方法执行前",
                    Hook_Option: @(AspectPositionBefore),
                    Hook_EventSelectorName: @"hookTest:",
                    Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                        NSLog(@"======== hookTest 执行前被钩住 =======");
                        NSLog(@"实例: %@, 方法: %@, 参数: %@",
                              aspectInfo.instance,
                              NSStringFromSelector(aspectInfo.originalInvocation.selector),
                              aspectInfo.arguments);
                    }
                },
                @{
                    Hook_EventName: @"方法执行后",
                    Hook_Option: @(AspectPositionAfter),
                    Hook_EventSelectorName: @"hookTest:",
                    Hook_EventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                        NSLog(@"======== hookTest 执行后被钩住 =======");
                        id returnVal;
                        [aspectInfo.originalInvocation getReturnValue:&returnVal];
                        NSLog(@"实例: %@, 方法: %@, 返回值: %@",
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

## API 文档

### 配置键

- **Hook_TrackedEvents**: 钩子事件字典数组
- **Hook_EventName**: 钩子的描述性名称（用于文档目的）
- **Hook_Option**: 钩子位置（AspectPositionBefore/After/Instead）
- **Hook_EventSelectorName**: 要钩入的方法的选择器名称
- **Hook_EventHandlerBlock**: 钩子触发时执行的 Block

### UIResponder 分类

```objective-c
@interface UIResponder(AspectHook)
+ (void)setupWithConfiguration:(NSDictionary *)configs;
@end
```

### AspectInfo 协议

AspectInfo 对象提供以下访问：
- `instance`: 被钩住的对象实例
- `originalInvocation`: 包含方法详情的 NSInvocation 对象
- `arguments`: 方法参数数组

## 示例项目

要运行示例项目，请克隆仓库并首先从 Example 目录运行 `pod install`。

```bash
git clone https://github.com/luowei/LWAspectsHook.git
cd LWAspectsHook/Example
pod install
open LWAspectsHook.xcworkspace
```

## 依赖库

- [Aspects](https://github.com/steipete/Aspects): 底层 AOP 库

## 作者

luowei, luowei@wodedata.com

## 许可证

LWAspectsHook 基于 MIT 许可证开源。详见 LICENSE 文件。
