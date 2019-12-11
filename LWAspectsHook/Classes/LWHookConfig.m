//
// Created by luowei on 15/9/14.
// Copyright (c) 2015 luowei. All rights reserved.
//

#import <Aspects/Aspects.h>
#import "LWHookConfig.h"

@implementation UIResponder(AspectHook)

+ (void)setupWithConfiguration:(NSDictionary *)configs {
    // Hook Events
    for (NSString *className in configs) {
        Class clazz = NSClassFromString(className);
        NSDictionary *config = configs[className];
        if(clazz==nil || config==nil){
            return;
        }

        if (config[Hook_TrackedEvents]) {
            for (NSDictionary *event in config[Hook_TrackedEvents]) {
                SEL selekor = NSSelectorFromString(event[Hook_EventSelectorName]);
                HookHandlerBlock block = event[Hook_EventHandlerBlock];

                if(selekor==nil || block == nil){
                    return;
                }

                [clazz aspect_hookSelector:selekor
                               withOptions:(AspectOptions) ((NSNumber *)event[Hook_Option]).intValue
                                usingBlock:^(id<AspectInfo> aspectInfo) {
                                    block(aspectInfo);
                                } error:NULL];

            }
        }
    }
}

@end