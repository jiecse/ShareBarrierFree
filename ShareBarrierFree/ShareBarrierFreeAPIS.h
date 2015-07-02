//
//  ShareBarrierFreeAPIS.h
//  ShareBarrierFree
//
//  Created by cisl on 15-6-15.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
NSString *ipAddr;

@interface ShareBarrierFreeAPIS : NSObject
+ (void)setIpAddr:(NSString *)setting;
+(NSString *)GetIPAddress;
//1 用户接口

//1.1 用户帐户登录
+ (NSDictionary *)MobileLogin:(NSString *)email password:(NSString *)password;

//1.2 注册用户
+(NSDictionary *)RegisterUser:(User *)user;

//1.3 查看用户详细信息
+(NSDictionary *)GetUserDetail;

//1.4 修改用户信息
+(NSDictionary *)ChangeUserDetail:(User *)user;

//1.5 查看用户发布的信息
+(NSDictionary *)GetUserReleaseList;

//2 发布查询


//2.1 搜索附近无障碍设施
+ (NSDictionary *)SearchNearbyBarrierFree:(double)longtitude latitude:(double)latitude;
//2.2 查看一条tag的详细内容
+ (NSDictionary *)GetDetailDescription:(int)infoId;
//2.3 上传一条tag
+ (NSDictionary *)UploadOneTag:(NSMutableDictionary *)dic;
//2.4 下载tag的图片
+ (NSDictionary *)DownloadPicture:(NSMutableDictionary *)dic;


@end
