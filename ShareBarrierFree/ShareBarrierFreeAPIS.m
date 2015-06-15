//
//  ShareBarrierFreeAPIS.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-15.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "ShareBarrierFreeAPIS.h"
NSString *ipAddr;

@implementation ShareBarrierFreeAPIS
+ (void)setIpAddr:(NSString *)setting
{
    ipAddr = setting;
}

+ (NSDictionary *)toDictionary:(NSData *)data
{
    NSError *error;

    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return json;
}

+(NSString *)GetIPAddress
{
    return ipAddr;
}

//1.1
+ (NSDictionary *)MobileLogin:(NSString *)username password:(NSString *)password
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/login.action?username=%@&&password=%@",ipAddr,username,password];
    NSLog(@"%@",urlString);
    
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSLog(@"error = %@",error);
    
    if (data)
    {
        NSLog(@"login in success %@",[self toDictionary:data]);
        return [self toDictionary:data];
    }
    else
    {
        NSLog(@"login in fail");
        return nil;
    }
    
}
//1.2
+ (NSDictionary *)MobileLogout
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/MyHomes/MobileLogout?sessionType=3", ipAddr];
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if (data)
        return [ShareBarrierFreeAPIS toDictionary:data];
    else
        return nil;
}
@end
