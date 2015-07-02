//
//  LoginViewController.h
//  ShareBarrierFree
//
//  Created by cisl on 15-6-15.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController{

    IBOutlet UITextField *passwordTextField;
    IBOutlet UITextField *usernameTextField;
}
- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)registerUser:(UIButton *)sender;

@end
