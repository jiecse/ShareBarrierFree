//
//  LocationInfo.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-18.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "LocationInfo.h"

@implementation LocationInfo
+(NSMutableArray *)getLocationInfos:(NSArray *)dataArray{
    NSMutableArray *momentsArray = [[NSMutableArray alloc] init];
    NSDictionary *dic;
    for (dic in dataArray) {
        LocationInfo *info =[[LocationInfo alloc] init];
        [info setInfoId:[[dic objectForKey:@"info_id"] intValue]];
        [info setTitle:[dic objectForKey:@"title"]];
        [info setTime:[dic objectForKey:@"time"]];
        [info setLongtitude:[[dic objectForKey:@"longitude"] doubleValue]];
        [info setLatitude:[[dic objectForKey:@"latitdue"] doubleValue]];
//        [info setUsername:[dic objectForKey:@"username"]];
//        [info setLongtitudeIndex:[dic objectForKey:@"longitudeIndex"]];
//        [info setLatitudeIndex:[dic objectForKey:@"latitude_index"]];
        [momentsArray addObject:info];
    }
    return momentsArray;
}
@end
