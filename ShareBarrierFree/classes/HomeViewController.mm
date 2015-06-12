//
//  HomeViewController.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-11.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "HomeViewController.h"
#import "NavigationViewController.h"
#import "AddTagViewController.h"
#import "TagDetailViewController.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface HomeViewController (){
    bool isGeoSearch;
    
}

@end

@implementation HomeViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    [self.navigationItem setTitle:@"主页"];
    // Here self.navigationController is an instance of NavigationViewController (which is a root controller for the main window)
    //
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(toggleMenu)];
    
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchNearby)];
    UIBarButtonItem *tagButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTag)];
    NSArray *itemArray=[[NSArray alloc]initWithObjects:searchButtonItem,tagButtonItem, nil];
    [self.navigationItem setRightBarButtonItems:itemArray];
    
    [_mapView setZoomLevel:18];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _mapView.showsUserLocation = YES;
    _locService = [[BMKLocationService alloc]init];
    [self startFollowing];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    NavigationViewController *navigationController = (NavigationViewController *)self.navigationController;
    [navigationController.menu setNeedsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchNearby{
    _reverseGeoCodeType = SearchTagReverseGeoCode;
    //删除所有标注
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    dispatch_async(kBgQueue, ^{
        //NSDictionary *oneDayGPSData = [SmartHomeAPIs GetOneDayGPSData:_searchDate.text];
//        if ([[oneDayGPSData objectForKey:@"result"] isEqualToString:@"fail"]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"获取gps数据失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alertView show];
//            });
//            return;
//        } else {
//            
//            NSArray *gpsDataList = [oneDayGPSData objectForKey:@"data"];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                int len = [gpsDataList count];
//                if (len == 0) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"当日数据为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                        [alertView show];
//                    });
//                    return;
//                }
//                for (int i=0; i<len; i++) {
//                    isGeoSearch = false;
//                    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
//                    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//                    NSDictionary *dic = [gpsDataList objectAtIndex:i];
//                    NSString *lon = [dic objectForKey:@"longitude"];
//                    NSString *lat = [dic objectForKey:@"latitude"];
//                    
//                    double longitude = [[lon substringWithRange:NSMakeRange(0, 3)] doubleValue] + [[lon substringFromIndex:3] doubleValue]/60;
//                    double latitude = [[lat substringWithRange:NSMakeRange(0, 2)] doubleValue] + [[lat substringFromIndex:2] doubleValue]/60;
//                    
//                    [self reverseGeocode:latitude andLongtitude:longitude];
//                    _geocodesearch = nil;
//                    _geocodesearch.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
//                }
//            });
//            
//        }
        NSArray *gpsList = @[
        @{@"lng": @121.606153, @"lat": @31.197365},
        @{@"lng": @121.606765, @"lat": @31.197322},
        @{@"lng": @121.604553, @"lat": @31.197765},
        @{@"lng": @121.606475, @"lat": @31.197355}];
        int len = [gpsList count];
        for (int i=0; i<len; i++) {
            
            NSDictionary *dic = [gpsList objectAtIndex:i];
            float lon = [[dic objectForKey:@"lng"] floatValue];
            float lat = [[dic objectForKey:@"lat"] floatValue];
            
            [self reverseGeocode:lat andLongtitude:lon];
            
        }
    });
}

-(void)addTag{
    _reverseGeoCodeType = AddTagReverseGeoCode;
    NSLog(@"lat=%f,lon=%f",self.latitude,self.longitude);
    BOOL isSuccess = [self reverseGeocode:self.latitude andLongtitude:self.longitude];
    if (self.latitude == 0 || self.longitude == 0 || isSuccess==false) {
        AddTagViewController *addTagViewController = [[AddTagViewController alloc] initWithNibName:@"AddTagViewController" bundle:nil];
        [addTagViewController.navigationItem setTitle:@"添加标记"];
        [self.navigationController pushViewController:addTagViewController animated:YES];
    }
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
////开始定位
//-(void)startLoaction{
//    NSLog(@"进入普通定位态");
//    _locService = [[BMKLocationService alloc]init];
//    _locService.delegate = self;
//    [_locService startUserLocationService];
//    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
//    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
//    _mapView.showsUserLocation = YES;//显示定位图层
//
//}
//跟随态
-(void)startFollowing
{
    NSLog(@"进入跟随态");
    
    [_locService startUserLocationService];
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    
}
//停止定位
-(void)stopLocation{
    [_locService stopUserLocationService];
    _mapView.showsUserLocation = NO;
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    //NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.longitude = userLocation.location.coordinate.longitude;
    self.latitude = userLocation.location.coordinate.latitude;
    [_mapView updateLocationData:userLocation];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
    
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
    
}

#pragma mark - 反地理编码 标记点

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    //NSLog(@"didAddAnnotationViews");
}


/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    TagDetailViewController *tagDetailViewController = [[TagDetailViewController alloc] initWithNibName:@"TagDetailViewController" bundle:nil];
    [self.navigationController pushViewController:tagDetailViewController animated:YES];
}

//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    return annotationView;
}


- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    //    [_mapView removeAnnotations:array];
    //    array = [NSArray arrayWithArray:_mapView.overlays];
    //    [_mapView removeOverlays:array];
    //NSLog(@"onGetReverseGeoCodeResult%d",[[NSArray arrayWithArray:_mapView.annotations] count]);
    
    if (error == 0) {
        if (_reverseGeoCodeType == SearchTagReverseGeoCode) {
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = result.location;
            item.title = result.address;
            [_mapView addAnnotation:item];
            _mapView.centerCoordinate = result.location;
            //        NSString* titleStr;
            //        NSString* showmeg;
            //        titleStr = @"反向地理编码";
            //        showmeg = [NSString stringWithFormat:@"%@",item.title];
            //
            //        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            //        [myAlertView show];
        }else if(_reverseGeoCodeType == AddTagReverseGeoCode) {
            AddTagViewController *addTagViewController = [[AddTagViewController alloc] initWithNibName:@"AddTagViewController" bundle:nil];
            [addTagViewController setCurrentLocation:result.address];
            [addTagViewController.navigationItem setTitle:@"添加标记"];
            [self.navigationController pushViewController:addTagViewController animated:YES];
        }
        
    }
}

-(BOOL)reverseGeocode:(double)lat andLongtitude:(double)lon
{
    isGeoSearch = false;
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    pt = (CLLocationCoordinate2D){lat, lon};
    //转换GPS坐标至百度坐标
//    NSDictionary *GPSDic = BMKConvertBaiduCoorFrom(pt,BMK_COORDTYPE_GPS);
//    pt = BMKCoorDictionaryDecode(GPSDic);
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    
    _geocodesearch = nil;
    _geocodesearch.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放

    if(flag)
    {
        return true;
        //NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
        return false;
    }
    
}
@end
