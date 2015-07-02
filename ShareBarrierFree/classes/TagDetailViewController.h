//
//  TagDetailViewController.h
//  ShareBarrierFree
//
//  Created by cisl on 15-6-12.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationInfo.h"
@interface TagDetailViewController : UIViewController{

    __weak IBOutlet UILabel *titleInfo;
    __weak IBOutlet UILabel *timeInfo;
    __weak IBOutlet UILabel *usernameInfo;
    __weak IBOutlet UITextView *detailDescription;
    __weak IBOutlet UIImageView *currentImageView;
    
}

@property(strong,nonatomic) LocationInfo *locationInfo;
@property(strong,nonatomic) UIImage *currentImage;
@end
