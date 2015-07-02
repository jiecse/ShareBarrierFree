//
//  ShareBarrierFreeAPIS.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-15.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "ShareBarrierFreeAPIS.h"
#import <CoreLocation/CoreLocation.h>
#import "MJExtension.h"
#import "LocationInfo.h"
#import "GVUserDefaults+Properties.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBJson4.h"
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

//1.1 登录
+ (NSDictionary *)MobileLogin:(NSString *)username password:(NSString *)password
{
    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:[[NSDictionary alloc]initWithObjectsAndKeys:username,@"username",password,@"password",nil] options:NSJSONWritingPrettyPrinted error:&error];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/barrierFree/user/user_login.action?requestStr=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);
    
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSLog(@"error = %@",error);
    
    if (data)
    {
        return [[ShareBarrierFreeAPIS toDictionary:data] objectForKey:@"jsonMap"];
    }
    
    return [[NSDictionary alloc]initWithObjectsAndKeys:@"fail",@"result",nil];

    
}


//1.2 注册用户
+(NSDictionary *)RegisterUser:(User *)user{
    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:user.keyValues options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/barrierFree/user/user_register.action?requestStr=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);
    
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        return [[ShareBarrierFreeAPIS toDictionary:data] objectForKey:@"jsonMap"];
    }
    //NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);
    
    return [[NSDictionary alloc]initWithObjectsAndKeys:@"fail",@"result",nil];
}
//1.3 查看用户详细信息
+(NSDictionary *)GetUserDetail{
    NSError *error = nil;
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/barrierFree/user/user_get_detail.action?user_id=%ld",ipAddr,(long)[GVUserDefaults standardUserDefaults].userId];
    NSLog(@"%@",urlString);
    
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        return [[ShareBarrierFreeAPIS toDictionary:data] objectForKey:@"jsonMap"];
    }
    //NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);
    
    return [[NSDictionary alloc]initWithObjectsAndKeys:@"fail",@"result",nil];
    return nil;
}

//1.4 修改用户信息
+(NSDictionary *)ChangeUserDetail:(User *)user{
    NSError *error = nil;
    NSMutableDictionary *dic = user.keyValues;
    [dic setObject:[NSNumber numberWithInteger:[GVUserDefaults standardUserDefaults].userId] forKey:@"user_id"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/barrierFree/user/user_set_detail.action?requestStr=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);
    
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        return [[ShareBarrierFreeAPIS toDictionary:data] objectForKey:@"jsonMap"];
    }
    //NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);
    
    return [[NSDictionary alloc]initWithObjectsAndKeys:@"fail",@"result",nil];
}

//1.5 查看用户发布的信息
+(NSDictionary *)GetUserReleaseList{
    NSError *error = nil;
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/barrierFree/user/user_get_info_list.action?user_id=%ld",ipAddr,(long)[GVUserDefaults standardUserDefaults].userId];
    NSLog(@"%@",urlString);
    
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        return [[ShareBarrierFreeAPIS toDictionary:data] objectForKey:@"jsonMap"];
    }
    //NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);
    
    return [[NSDictionary alloc]initWithObjectsAndKeys:@"fail",@"result",nil];
}

//2.1搜索附近无障碍设施
+ (NSDictionary *)SearchNearbyBarrierFree:(double)longtitude latitude:(double)latitude{
//    NSArray *locationList = @[
//                         @{@"longtitude": @121.606153, @"latitude": @31.197365, @"addressInfo": @"你在1"},
//                         @{@"longtitude": @121.606765, @"latitude": @31.197322, @"addressInfo": @"你在2"},
//                         @{@"longtitude": @121.604553, @"latitude": @31.197765, @"addressInfo": @"你在3"},
//                         @{@"longtitude": @121.606475, @"latitude": @31.197355, @"addressInfo": @"你在4"}];
//    NSArray *locationInfoArray = [LocationInfo objectArrayWithKeyValuesArray:locationList];
//    return [[NSDictionary alloc]initWithObjectsAndKeys:@"success",@"result",locationInfoArray,@"data",nil];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc] initWithDouble:longtitude] , @"longitude", [[NSNumber alloc] initWithDouble:latitude], @"latitude", nil];
    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/barrierFree/info/info_get_distance_list.action?requestStr=%@",ipAddr,jsonString];
    NSLog(@"%@",urlString);
    
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        return [[ShareBarrierFreeAPIS toDictionary:data] objectForKey:@"jsonMap"];
    }
    //NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);
    
    return [[NSDictionary alloc]initWithObjectsAndKeys:@"fail",@"result",nil];
    
}
//2.2 查看一条tag的详细内容
+ (NSDictionary *)GetDetailDescription:(int)infoId{
    NSError *error = nil;
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/barrierFree/info/info_get_detail.action?info_id=%d",ipAddr,infoId];
    NSLog(@"%@",urlString);
    
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        return [[ShareBarrierFreeAPIS toDictionary:data] objectForKey:@"jsonMap"];
    }
    //NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);
    
    return [[NSDictionary alloc]initWithObjectsAndKeys:@"fail",@"result",nil];

}

//2.3 上传一条tag
+ (NSDictionary *)UploadOneTag:(NSMutableDictionary *)dic{
    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [@"requestStr=" stringByAppendingString:[[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding]];
    //NSLog(@"%@",jsonString);
//    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/barrierFree/info/info_add.action",ipAddr];
//    NSLog(@"%@",urlString);
//    
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:requestData];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:20];//请求这个地址， timeoutInterval:10 设置为10s超时：请求时间超过10s会被认为连接不上，连接超时
    
    [request setHTTPMethod:@"POST"];//POST请求
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];//body 数据
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];//请求头
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];//异步发送request，成功后会得到服务器返回的数据
    
    
    if (returnData)
    {
        NSLog(@"returndata = %@", [ShareBarrierFreeAPIS toDictionary:returnData]);
        return [[ShareBarrierFreeAPIS toDictionary:returnData] objectForKey:@"jsonMap"];

    }else{
        NSLog(@"returndata = %@", @"服务器无响应");

    }
    
    return [[NSDictionary alloc]initWithObjectsAndKeys:@"fail",@"result",nil];
    
    
}

//2.4 下载tag的图片
+ (NSDictionary *)DownloadPicture:(NSMutableDictionary *)dic{
    NSError *error=nil;
    NSURL *url=[NSURL URLWithString:@"http://ww3.sinaimg.cn/mw690/51f76ed7jw1e3ohzmmnffj.jpg"];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    NSData *imgData=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    UIImage *img=nil;
    if(imgData)
    {
        img=[UIImage imageWithData:imgData];
    }
    
//    Base64字符串转UIImage图片：
//    NSData *decodedImageData = [[NSData alloc]
//                                initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    return nil;
}
@end
