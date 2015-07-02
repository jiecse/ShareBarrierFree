//
//  LocationInfo.h
//  ShareBarrierFree
//
//  Created by cisl on 15-6-18.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationInfo : NSObject
@property(assign,nonatomic) int infoId;
@property(strong,nonatomic) NSString * title;
@property(strong,nonatomic) NSString * time;
@property(assign,nonatomic) double longtitude;
@property(assign,nonatomic) double latitude;
@property(strong,nonatomic) NSString * longtitudeIndex;
@property(strong,nonatomic) NSString * latitudeIndex;
@property(strong,nonatomic) NSString * username;
@property(strong,nonatomic) NSString * detailDescription;
@property(strong,nonatomic) NSString * pictureUrl;
@property(strong,nonatomic) NSData * picture;

@property(nonatomic) int userId;



//@property(assign,nonatomic) CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
//@property(strong,nonatomic) UIImage * image;

+(NSMutableArray *)getLocationInfos:(NSArray *)dataArray;

@end
