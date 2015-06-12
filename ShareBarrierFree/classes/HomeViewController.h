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
//经度
@property (nonatomic, assign) double longitude;

//纬度
@property (nonatomic, assign) double latitude;


typedef enum {
    AddTagReverseGeoCode,
    SearchTagReverseGeoCode
}ReverseGeoCodeType;
@property (nonatomic, assign) ReverseGeoCodeType reverseGeoCodeType;
@end
