//
//  Moment.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-29.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "Moment.h"

@implementation Moment
+(NSMutableArray *)getMoments:(NSArray *)dataArray{
    NSMutableArray *momentsArray = [[NSMutableArray alloc] init];
    NSDictionary *dic;
    for (dic in dataArray) {
        Moment *moment =[[Moment alloc] init];
        [moment setInfoId:[[dic objectForKey:@"info_id"] intValue]];
        [moment setTitle:[dic objectForKey:@"title"]];
        [moment setTime:[dic objectForKey:@"time"]];
        [moment setLongtitude:[[dic objectForKey:@"longitude"] doubleValue]];
        [moment setLongtitudeIndex:[dic objectForKey:@"longitudeIndex"]];
        [moment setLatitude:[[dic objectForKey:@"latitude"] doubleValue]];
        [moment setLatitude_index:[dic objectForKey:@"latitude_index"]];
        [moment setDetailDescription:[dic objectForKey:@"description"]];
        [momentsArray addObject:moment];
    }
    return momentsArray;
}
@end
