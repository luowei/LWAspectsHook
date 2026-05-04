# Graph Report - /Users/luowei/projects/libs/LWAspectsHook  (2026-05-04)

## Corpus Check
- Corpus is ~14,458 words - fits in a single context window. You may not need a graph.

## Summary
- 141 nodes · 162 edges · 14 communities detected
- Extraction: 88% EXTRACTED · 12% INFERRED · 0% AMBIGUOUS · INFERRED: 19 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]

## God Nodes (most connected - your core abstractions)
1. `HookEvent` - 13 edges
2. `HookConfiguration` - 11 edges
3. `LWAppDelegate` - 9 edges
4. `HookManager` - 6 edges
5. `HookOption` - 6 edges
6. `View` - 6 edges
7. `HookConfigurationBuilder` - 5 edges
8. `HookEventBuilder` - 5 edges
9. `HookSetupModifier` - 5 edges
10. `LWHookDebug` - 5 edges

## Surprising Connections (you probably didn't know these)
- `SwiftUIAppExample` --inherits--> `View`  [EXTRACTED]
  Example/SwiftExample/UsageExamples.swift →   _Bridges community 0 → community 4_

## Communities (20 total, 5 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.12
Nodes (11): HookEvent, HookSetupExample, AdvancedSwiftUIExample, AnalyticsHookExample, BasicUIKitExample, DebugLoggingExample, MainContentView, MethodReplacementExample (+3 more)

### Community 1 - "Community 1"
Cohesion: 0.13
Nodes (6): Identifiable, ObservableObject, ClassHookConfiguration, HookEventBuilder, HookEventLog, HookManager

### Community 2 - "Community 2"
Cohesion: 0.16
Nodes (6): HookConfigurationPreview, HookDebugView, HookEventMonitorView, HookSetupModifier, View, ViewModifier

### Community 3 - "Community 3"
Cohesion: 0.17
Nodes (8): Int, ClassHookConfiguration, HookConfigKeys, HookOption, after, before, instead, LWMigrationHelper

### Community 4 - "Community 4"
Cohesion: 0.22
Nodes (8): App, PreviewProvider, SwiftUISupport_Previews, ContentView, ContentView_Previews, ExampleApp, ExampleView, View

### Community 5 - "Community 5"
Cohesion: 0.2
Nodes (3): LWAspectsHookSwift, LWHook, LWHookDebug

### Community 6 - "Community 6"
Cohesion: 0.2
Nodes (9): LWAppDelegate, -applicationDidBecomeActive, -applicationDidEnterBackground, -applicationdidFinishLaunchingWithOptions, -applicationWillEnterForeground, -applicationWillResignActive, -applicationWillTerminate, -hookEventDict (+1 more)

### Community 9 - "Community 9"
Cohesion: 0.4
Nodes (4): Tests, -setUp, -tearDown, -testExample

### Community 11 - "Community 11"
Cohesion: 0.5
Nodes (3): LWViewController, -hookTest, -viewDidLoad

## Knowledge Gaps
- **18 isolated node(s):** `-setupWithConfiguration`, `before`, `instead`, `after`, `HookConfigKeys` (+13 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `HookEvent` connect `Community 0` to `Community 8`, `Community 3`, `Community 4`?**
  _High betweenness centrality (0.286) - this node is a cross-community bridge._
- **Why does `HookConfiguration` connect `Community 7` to `Community 8`, `Community 0`, `Community 3`?**
  _High betweenness centrality (0.246) - this node is a cross-community bridge._
- **Are the 11 inferred relationships involving `HookEvent` (e.g. with `.convertFromObjC()` and `.hook()`) actually correct?**
  _`HookEvent` has 11 INFERRED edges - model-reasoned connections that need verification._
- **Are the 7 inferred relationships involving `HookConfiguration` (e.g. with `.buildBlock()` and `.buildArray()`) actually correct?**
  _`HookConfiguration` has 7 INFERRED edges - model-reasoned connections that need verification._
- **What connects `-setupWithConfiguration`, `before`, `instead` to the rest of the system?**
  _18 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.12 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.13 - nodes in this community are weakly interconnected._