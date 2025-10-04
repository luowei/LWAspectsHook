#
# LWAspectsHookSwift.podspec
# Swift/SwiftUI version of LWAspectsHook
#

Pod::Spec.new do |s|
  s.name             = 'LWAspectsHookSwift'
  s.version          = '1.0.0'
  s.summary          = 'Swift/SwiftUI version of LWAspectsHook - A powerful AOP hook utility for iOS'

  s.description      = <<-DESC
LWAspectsHookSwift is a modern Swift/SwiftUI implementation of the LWAspectsHook library.
It provides a clean, type-safe API for aspect-oriented programming with support for:
- Swift-native configuration using structs and enums
- SwiftUI integration with view modifiers and observables
- Result builders for declarative hook setup
- Debug monitoring views for development
- Full compatibility with the original Objective-C API
                       DESC

  s.homepage         = 'https://github.com/luowei/LWAspectsHook.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luowei' => 'luowei@wodedata.com' }
  s.source           = { :git => 'https://github.com/luowei/LWAspectsHook.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'LWAspectsHook_swift/SwiftClasses/**/*'

  s.frameworks = 'UIKit', 'SwiftUI', 'Combine'
  s.dependency 'Aspects'

  # Optional: Include the original Objective-C files for compatibility
  # s.dependency 'LWAspectsHook'
end
