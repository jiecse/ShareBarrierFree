//
//  RegisterViewController.h
//  ShareBarrierFree
//
//  Created by cisl on 15-6-29.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface RegisterViewController : UIViewController{

    __weak IBOutlet UITextField *username;
    __weak IBOutlet UITextField *password;
    __weak IBOutlet UITextField *verifyPassword;
    __weak IBOutlet UITextField *address;
    __weak IBOutlet UITextField *email;
    __weak IBOutlet UITextField *phoneNumbner;
}
@property (strong, nonatomic) IBOutlet UIView *inputView;
@property (strong, nonatomic)User *user;

- (IBAction)registerBtnClicked:(UIButton *)sender;
- (IBAction)moveView:(UITextField *)sender;

@end
