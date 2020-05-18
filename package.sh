# 指定Name
LibName="LWAspectsHook"

# framework
pod package ${LibName}.podspec --force --no-mangle --configuration=Release

# .a
# pod package LWAspectsHook.podspec --force --library --configuration=Release

