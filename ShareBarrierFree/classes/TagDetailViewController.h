//
//  TagDetailViewController.h
//  ShareBarrierFree
//
//  Created by cisl on 15-6-12.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagDetailViewController : UIViewController{

    IBOutlet UITextView *addressTextView;
    IBOutlet UIImageView *currentImageView;
}

@property(strong,nonatomic) NSString *currentAddress;
@property(strong,nonatomic) UIImage *currentImage;
@end
