//
//  Moment.h
//  ShareBarrierFree
//
//  Created by cisl on 15-6-29.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Moment : NSObject
@property(nonatomic,assign)int infoId;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * time;
@property(nonatomic,assign)double longtitude;
@property(nonatomic,strong)NSString * longtitudeIndex;
@property(nonatomic,assign)double latitude;
@property(nonatomic,strong)NSString * latitude_index;
@property(nonatomic,strong)NSString * detailDescription;

+(NSMutableArray *)getMoments:(NSArray *)dataArray;
@end
