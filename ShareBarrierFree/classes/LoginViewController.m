//
//  LoginViewController.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-15.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "LoginViewController.h"
#import "ProgressHUD.h"
#import "RootController.h"
#import "RegisterViewController.h"
#import "ShareBarrierFreeAPIS.h"
#import "GVUserDefaults+Properties.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击空白区域，键盘收起
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)loginButtonClicked:(id)sender {
    NSString *username;
    NSString *password;
    
    username = [NSString stringWithString:usernameTextField.text];
    password = [NSString stringWithString:passwordTextField.text];
    
    
    //用来测试用的用户名密码
    if ([username isEqualToString:@""])
    {
        [ProgressHUD showError:@"用户名不能为空"];
        return;
    }
    if ([password isEqualToString:@""])
    {
        [ProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    [ProgressHUD show:@"正在登录"];
    self.view.userInteractionEnabled = false;
    
    dispatch_async(serverQueue, ^{
        NSDictionary *resultDic = [ShareBarrierFreeAPIS MobileLogin:username password:password];

        if ([[resultDic objectForKey:@"result"] isEqualToString:@"success"]) {
            [GVUserDefaults standardUserDefaults].userId = [[resultDic objectForKey:@"user_id"] integerValue];
            [GVUserDefaults standardUserDefaults].username = username;
            
            [GVUserDefaults standardUserDefaults].password = password;
            [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"登录成功" waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(switchNextViewController) withObject:nil waitUntilDone:YES];
            return ;
        }
        else//登录出错
        {
            [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"登录失败！" waitUntilDone:YES];
            return ;
        }
    });

}

- (IBAction)registerUser:(UIButton *)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:registerVC];
    [nav.navigationBar performSelector:@selector(setBarTintColor:) withObject:[UIColor colorWithRed:0/255.0 green:213/255.0 blue:161/255.0 alpha:1]];

    [registerVC.navigationItem setTitle:@"注册新用户"];
    [self.view.window.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (void) successWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showSuccess:message];
}

- (void) errorWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showError:message];
}

- (void)switchNextViewController
{
    RootController *rootController = (RootController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rootController switchToMainTabBarView];
}
@end
