//
//  MWUtils.m
//  MoinWiki
//
//  Created by Just Zhang on 12-3-9.
//  Copyright 2012年 BTBU. All rights reserved.
//

#import "MWUtils.h"
#import "UKLoginItemRegistry.h"

@implementation MWUtils

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


#pragma mark Check if the app set as Login Item.
+ (bool)isAppSetToRunAtLogon {
    int ret = [UKLoginItemRegistry indexForLoginItemWithPath:[[NSBundle mainBundle] bundlePath]];
    NSLog(@"login item index = %i", ret);
    return (ret >= 0);
}

#pragma mark Toggle the Login Item setting.
+ (void)toggleOpenAtLogon:(id)sender {
    if ([MWUtils isAppSetToRunAtLogon]) {
        [UKLoginItemRegistry removeLoginItemWithPath:[[NSBundle mainBundle] bundlePath]];
    } else {
        [UKLoginItemRegistry addLoginItemWithPath:[[NSBundle mainBundle] bundlePath] hideIt: NO];
    }
}

@end
