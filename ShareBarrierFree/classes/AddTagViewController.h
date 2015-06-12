//
//  AddTagViewController.h
//  ShareBarrierFree
//
//  Created by cisl on 15-6-12.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTagViewController : UIViewController{

    IBOutlet UITextField *describeText;
    IBOutlet UIImageView *imageView;
}
- (IBAction)uploadPictureBtn:(id)sender;

@end
