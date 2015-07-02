//
//  UserDetailViewController.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-30.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "UserDetailViewController.h"
#import "GVUserDefaults+Properties.h"
#import "ProgressHUD.h"
#import "ShareBarrierFreeAPIS.h"
@interface UserDetailViewController ()

@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    [self.navigationItem setTitle:@"账号详情"];
    
    // Here self.navigationController is an instance of NavigationViewController (which is a root controller for the main window)
    //
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(changeInfo)];
    
    [username setText:self.user.username];
    [password setText:self.user.password];
    [address setText:self.user.address];
    [email setText:self.user.email];
    [phone setText:self.user.phone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeInfo{
    [password setText:[GVUserDefaults standardUserDefaults].password];
    [username setUserInteractionEnabled:TRUE];
    [password setUserInteractionEnabled:TRUE];
    [address setUserInteractionEnabled:TRUE];
    [email setUserInteractionEnabled:TRUE];
    [phone setUserInteractionEnabled:TRUE];
    [username setBackgroundColor:[UIColor whiteColor]];
    [password setBackgroundColor:[UIColor whiteColor]];
    [address setBackgroundColor:[UIColor whiteColor]];
    [email setBackgroundColor:[UIColor whiteColor]];
    [phone setBackgroundColor:[UIColor whiteColor]];
    [changeBtn setHidden:FALSE];
}

- (IBAction)changeBtnClicked:(UIButton *)sender {
    User *changedUser = [[User alloc] init];
    [changedUser setUsername:[NSString stringWithString:username.text]];
    [changedUser setPassword:[NSString stringWithString:password.text]];
    [changedUser setAddress:[NSString stringWithString:address.text]];
    [changedUser setEmail:[NSString stringWithString:address.text]];
    [changedUser setPhone:[NSString stringWithString:phone.text]];
    
    BOOL isInfoRight = [changedUser verifyInfo:[NSString stringWithString:[GVUserDefaults standardUserDefaults].password]];
    if (isInfoRight== TRUE) {
        [ProgressHUD show:@"正在修改"];
        self.view.userInteractionEnabled = false;
        
        dispatch_async(serverQueue, ^{
            NSDictionary *resultDic = [ShareBarrierFreeAPIS ChangeUserDetail:changedUser];
            if ([[resultDic objectForKey:@"result"] isEqualToString:@"success"]) {
                self.user = changedUser;
                //[self.user saveUserInfo:[[resultDic objectForKey:@"user_id"] integerValue]];
                [self performSelectorOnMainThread:@selector(changeSuccessd:) withObject:@"修改成功" waitUntilDone:YES];
                // [self performSelectorOnMainThread:@selector(switchNextViewController) withObject:nil waitUntilDone:YES];
                
            }else
            {
                [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"修改失败！" waitUntilDone:YES];
                return ;
            }
        });
    }
    
    
    
}

- (IBAction)moveInfoView:(UITextField *)sender {
    
    CGRect frame = self.infoView.frame;
    //NSLog(@"inputView = %f",self.inputView.frame.origin.y);
    if (sender.tag>0) {
        frame.origin.y = -25*sender.tag;
        //NSLog(@"frame = %f",frame.origin.y);
        
        [UIView animateWithDuration:0.5f
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:0.1f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.infoView.frame = frame;}
                         completion:^(BOOL finished) {}];
    }

}

//点击空白区域，键盘收起
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGRect frame = self.infoView.frame;
    frame.origin.y = 50;
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.infoView.frame = frame;}
                     completion:^(BOOL finished) {}];
    [self.view endEditing:YES];
}
- (void) changeSuccessd:(NSString *)message {
    [self.user saveUserInfo:[GVUserDefaults standardUserDefaults].userId];
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showSuccess:message];

    [changeBtn setHidden:TRUE];
    [username setUserInteractionEnabled:FALSE];
    [password setUserInteractionEnabled:FALSE];
    [address setUserInteractionEnabled:FALSE];
    [email setUserInteractionEnabled:FALSE];
    [phone setUserInteractionEnabled:FALSE];
    [username setBackgroundColor:[UIColor colorWithWhite:0.90 alpha:1.000]];
    [password setBackgroundColor:[UIColor colorWithWhite:0.90 alpha:1.000]];
    [address setBackgroundColor:[UIColor colorWithWhite:0.90 alpha:1.000]];
    [email setBackgroundColor:[UIColor colorWithWhite:0.90 alpha:1.000]];
    [phone setBackgroundColor:[UIColor colorWithWhite:0.90 alpha:1.000]];
    [password setText:@""];
}
- (void) errorWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showError:message];
}
@end
