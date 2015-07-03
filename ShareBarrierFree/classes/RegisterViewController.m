//
//  RegisterViewController.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-29.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "RegisterViewController.h"
#import "User.h"
#import "ShareBarrierFreeAPIS.h"
#import "ProgressHUD.h"
#import "GVUserDefaults+Properties.h"
#import "RootController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    self.user= [[User alloc] init];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(returnToLogin)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)returnToLogin{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerBtnClicked:(UIButton *)sender {
    [self.user setUsername:[NSString stringWithString:username.text]];
    [self.user setPassword:[NSString stringWithString:password.text]];
    [self.user setAddress:[NSString stringWithString:address.text]];
    [self.user setEmail:[NSString stringWithString:address.text]];
    [self.user setPhone:[NSString stringWithString:phoneNumbner.text]];
    
    BOOL isInfoRight = [self.user verifyInfo:[NSString stringWithString:verifyPassword.text]];
    if (isInfoRight== TRUE) {
        [ProgressHUD show:@"正在注册"];
        self.view.userInteractionEnabled = false;
        
        dispatch_async(serverQueue, ^{
            NSDictionary *resultDic = [ShareBarrierFreeAPIS RegisterUser:self.user];
            if ([[resultDic objectForKey:@"result"] isEqualToString:@"success"]) {
                
                [self.user setUser_id:[[resultDic objectForKey:@"user_id"] integerValue]];
                [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"注册成功" waitUntilDone:YES];
               // [self performSelectorOnMainThread:@selector(switchNextViewController) withObject:nil waitUntilDone:YES];

            }else//登录出错
            {
                [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"注册失败！" waitUntilDone:YES];
                return ;
            }
        });
    }
}

- (IBAction)moveView:(UITextField *)sender {
    CGRect frame = self.inputView.frame;
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
                             self.inputView.frame = frame;}
                         completion:^(BOOL finished) {}];
    }
    
}

//点击空白区域，键盘收起
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGRect frame = self.inputView.frame;
    frame.origin.y = 50;
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.inputView.frame = frame;}
                     completion:^(BOOL finished) {}];
    [self.view endEditing:YES];
}

- (void) successWithMessage:(NSString *)message {
    [GVUserDefaults standardUserDefaults].userId = self.user.user_id;
    [GVUserDefaults standardUserDefaults].username = self.user.username;
    
    [GVUserDefaults standardUserDefaults].password = self.user.password;
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showSuccess:message];
    [self returnToLogin];
}
- (void) errorWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showError:message];
}
@end
