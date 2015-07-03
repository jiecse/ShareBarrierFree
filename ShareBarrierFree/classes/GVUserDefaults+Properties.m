//
//  GVUserDefaults+Properties.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-29.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "GVUserDefaults+Properties.h"

@implementation GVUserDefaults (Properties)
@dynamic userId;
@dynamic username;
@dynamic password;
@dynamic address;
@dynamic email;
@dynamic phone;

- (NSDictionary *)setupDefaults {
    return @{
             @"username": @"",
             @"password": @"",
             @"address": @"",
             @"email":@"",
             @"phone":@"",
             };
}

- (NSString *)transformKey:(NSString *)key {
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[key substringToIndex:1] uppercaseString]];
    return [NSString stringWithFormat:@"NSUserDefault%@", key];
}

@end
