//
//  LWViewController.m
//  LWAspectsHook
//
//  Created by luowei on 12/11/2019.
//  Copyright (c) 2019 luowei. All rights reserved.
//

#import "LWViewController.h"

@interface LWViewController ()

@end

@implementation LWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self hookTest:@"hi"];
}

-(NSString *)hookTest:(NSString *)testStr {
    NSString *str = @"hello world!";
    if([testStr isEqualToString:@"hi"]){
        str = @"fine, thank you!";
    }
    return str;
}

@end
