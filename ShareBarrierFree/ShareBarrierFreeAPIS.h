//
//  ShareBarrierFreeAPIS.h
//  ShareBarrierFree
//
//  Created by cisl on 15-6-15.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
NSString *ipAddr;

@interface ShareBarrierFreeAPIS : NSObject
+ (void)setIpAddr:(NSString *)setting;
+(NSString *)GetIPAddress;

//1.1用户帐户登录
+ (NSDictionary *)MobileLogin:(NSString *)email password:(NSString *)password;

//1.2注销登录
+ (NSDictionary *)MobileLogout;
@end
