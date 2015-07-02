//
//  GVUserDefaults+Properties.h
//  ShareBarrierFree
//
//  Created by cisl on 15-6-29.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "GVUserDefaults.h"

@interface GVUserDefaults (Properties)
@property (nonatomic) NSInteger userId;
@property(weak,nonatomic)NSString *username;
@property(weak,nonatomic)NSString *password;
@property(weak,nonatomic)NSString *address;
@property(weak,nonatomic)NSString *email;
@property(weak,nonatomic)NSString *phone;
@end
