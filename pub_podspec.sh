#!/bin/sh

pod trunk push ./LWAspectsHook.podspec --verbose --allow-warnings

# pod repo push mygitlabrepo LWAspectsHook.podspec --verbose --allow-warnings --sources="https://github.com/CocoaPods/Specs.git"