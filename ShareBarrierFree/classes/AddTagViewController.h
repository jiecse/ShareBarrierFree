//
//  AddTagViewController.h
//  ShareBarrierFree
//
//  Created by cisl on 15-6-12.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI/BMapKit.h>

@interface AddTagViewController : UIViewController<BMKMapViewDelegate>{


    __weak IBOutlet UITextField *titleText;
    IBOutlet UITextView *detailDescrption;
    IBOutlet BMKMapView *mapView;
    
    IBOutlet UIImageView *imageView;
}
- (IBAction)uploadPictureBtn:(id)sender;
- (IBAction)textFiledReturnEditing:(id)sender;
@property(nonatomic,assign) CLLocationCoordinate2D pt;
@end
