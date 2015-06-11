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

@interface HomeViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate>{

    IBOutlet BMKMapView *_mapView;
    BMKLocationService* _locService;

}

@end
