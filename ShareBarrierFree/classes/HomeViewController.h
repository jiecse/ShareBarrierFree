//
//  HomeViewController.h
//  ShareBarrierFree
//
//  Created by cisl on 15-6-11.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "REMenu.h"

@interface HomeViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{

    IBOutlet BMKMapView *_mapView;
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
    
    
}
//当前经度
@property (nonatomic, assign) double longitude;
//当前纬度
@property (nonatomic, assign) double latitude;

//当前经纬度
@property (nonatomic, assign) CLLocationCoordinate2D pt;

//是否获取到当前位置的经纬度
@property(nonatomic,assign) BOOL isGetLatLong;
//附近无障碍设施数组
@property(nonatomic,strong) NSArray *locationInfoArray;

//用于存放搜索到的pointAnnotation数组
@property(nonatomic,strong) BMKMapView *searchedPointAnnotations;

typedef enum {
    AddTagReverseGeoCode,
    SearchTagReverseGeoCode
}ReverseGeoCodeType;
@property (nonatomic, assign) ReverseGeoCodeType reverseGeoCodeType;
@end
